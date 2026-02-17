#!/bin/bash

# ===== НАСТРОЙКИ ПО УМОЛЧАНИЮ =====
DRY_RUN=false
MOVE_FILES=false  # По умолчанию не перемещаем файлы

# ===== ФУНКЦИЯ ПОМОЩИ =====
show_help() {
    echo "Использование: $0 [ОПЦИИ] <директория>"
    echo ""
    echo "Опции:"
    echo "  -n, --dry-run        Пробный запуск (без реальных изменений)"
    echo "  -m, --move           Переместить файлы в папки по расширениям"
    echo "  -h, --help           Показать эту справку"
    echo ""
    echo "Примеры:"
    echo "  $0 /home/user/files              # Только просмотр"
    echo "  $0 --move /home/user/files       # Просмотр + перемещение"
    echo "  $0 --dry-run --move /home/user/files  # Показать, что будет перемещено"
}

# ===== ОБРАБОТКА АРГУМЕНТОВ =====
DIRECTORY=""

while [ $# -gt 0 ]; do
    case "$1" in
        -n|--dry-run)
            DRY_RUN=true
            echo "🔍 РЕЖИМ ПРОБНОГО ЗАПУСКА - файлы НЕ БУДУТ перемещены"
            echo "===================================="
            shift
            ;;
        -m|--move)
            MOVE_FILES=true
            echo "📦 РЕЖИМ ПЕРЕМЕЩЕНИЯ - файлы будут рассортированы по папкам"
            echo "===================================="
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            echo "❌ Неизвестная опция: $1"
            show_help
            exit 1
            ;;
        *)
            DIRECTORY="$1"
            shift
            ;;
    esac
done

# ===== ПРОВЕРКА ДИРЕКТОРИИ =====
if [ -z "$DIRECTORY" ]; then
    echo "❌ Ошибка: Не указана директория"
    show_help
    exit 1
fi

if [ ! -d "$DIRECTORY" ]; then
    echo "❌ Ошибка: Директория '$DIRECTORY' не существует"
    exit 1
fi

# Переходим в целевую директорию
cd "$DIRECTORY" || exit 1
echo "📁 Работаем в директории: $(pwd)"
echo "===================================="

# ===== ПРОВЕРКА УТИЛИТ =====
echo ""
echo "🔧 Проверка установки утилит"
echo "===================================="

for tool in mp3info pdfinfo file unzip; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "✅ $tool: установлена"
    else 
        echo "❌ $tool: не установлена"
    fi
done

echo "===================================="
echo ""

# ===== ФУНКЦИЯ СОЗДАНИЯ ДИРЕКТОРИИ =====
create_dir_if_not_exists() {
    local dir_name="$1"
    
    if [ ! -d "$dir_name" ]; then
        if [ "$DRY_RUN" = true ]; then
            echo "   🔍 [dry-run] Будет создана папка: $dir_name/"
        else
            mkdir "$dir_name"
            echo "   📁 Создана папка: $dir_name/"
        fi
    fi
}

# ===== ФУНКЦИЯ ПЕРЕМЕЩЕНИЯ ФАЙЛА =====
move_file() {
    local file="$1"
    local target_dir="$2"
    local filename=$(basename "$file")
    
    if [ "$MOVE_FILES" = true ]; then
        # Создаем целевую папку, если нужно
        create_dir_if_not_exists "$target_dir"
        
        # Проверяем, не существует ли уже такой файл в целевой папке
        if [ -f "$target_dir/$filename" ]; then
            # Если файл существует, добавляем префикс с датой
            local new_name="$(date +%Y%m%d)_$filename"
            echo "   ⚠️  Файл уже существует, будет переименован: $new_name"
            
            if [ "$DRY_RUN" = true ]; then
                echo "   🔍 [dry-run] Будет перемещен: $file → $target_dir/$new_name"
            else
                mv "$file" "$target_dir/$new_name"
                echo "   ✅ Перемещен: $filename → $target_dir/$new_name"
            fi
        else
            if [ "$DRY_RUN" = true ]; then
                echo "   🔍 [dry-run] Будет перемещен: $file → $target_dir/"
            else
                mv "$file" "$target_dir/"
                echo "   ✅ Перемещен: $filename → $target_dir/"
            fi
        fi
    fi
}

# ===== ФУНКЦИИ ОБРАБОТКИ ФАЙЛОВ =====
process_txt_file() {
    local file="$1"
    echo "📄 Текстовый файл: $(basename "$file")"
    
    if [ "$DRY_RUN" = true ]; then
        echo "   🔍 [dry-run] Будет подсчет слов и строк"
    else
        echo "   Слов: $(wc -w < "$file" 2>/dev/null || echo 'ошибка')"
        echo "   Строк: $(wc -l < "$file" 2>/dev/null || echo 'ошибка')"
    fi
    
    move_file "$file" "text_files"
}

process_pdf_file() {
    local file="$1"
    echo "📕 PDF файл: $(basename "$file")"
    
    if [ "$DRY_RUN" = true ]; then
        echo "   🔍 [dry-run] Будет извлечен заголовок PDF"
    else
        if command -v pdfinfo >/dev/null 2>&1; then
            pdfinfo "$file" 2>/dev/null | grep Title | sed 's/^/   /' || echo "   Заголовок не найден"
        fi
    fi
    
    move_file "$file" "pdf_files"
}

process_jpg_file() {
    local file="$1"
    echo "🖼️  JPEG изображение: $(basename "$file")"
    
    if [ "$DRY_RUN" = true ]; then
        echo "   🔍 [dry-run] Будет определена информация об изображении"
    else
        file "$file" | cut -d: -f2- | sed 's/^/   /'
    fi
    
    move_file "$file" "jpg_files"
}

process_png_file() {
    local file="$1"
    echo "🖼️  PNG изображение: $(basename "$file")"
    
    if [ "$DRY_RUN" = true ]; then
        echo "   🔍 [dry-run] Будет определена информация об изображении"
    else
        file "$file" | cut -d: -f2- | sed 's/^/   /'
    fi
    
    move_file "$file" "png_files"
}

process_sh_file() {
    local file="$1"
    echo "🐚 Bash скрипт: $(basename "$file")"
    
    if [ "$DRY_RUN" = true ]; then
        echo "   🔍 [dry-run] Будет проверка синтаксиса"
    else
        if bash -n "$file" 2>/dev/null; then
            echo "   ✅ Синтаксис верный"
        else
            echo "   ❌ Ошибка в синтаксисе"
        fi
    fi
    
    move_file "$file" "bash_scripts"
}

process_zip_file() {
    local file="$1"
    echo "📦 ZIP архив: $(basename "$file")"
    
    if [ "$DRY_RUN" = true ]; then
        echo "   🔍 [dry-run] Будет показано содержимое архива"
    else
        if command -v unzip >/dev/null 2>&1; then
            echo "   Содержимое (первые 3 файла):"
            unzip -l "$file" 2>/dev/null | tail -n +4 | head -3 | sed 's/^/     /' || echo "   Ошибка чтения"
        fi
    fi
    
    move_file "$file" "zip_archives"
}

process_mp3_file() {
    local file="$1"
    echo "🎵 MP3 файл: $(basename "$file")"
    
    if [ "$DRY_RUN" = true ]; then
        echo "   🔍 [dry-run] Будет прочитана информация о тегах"
    else
        if command -v mp3info >/dev/null 2>&1; then
            mp3info -p "   Название: %t\n   Исполнитель: %a\n" "$file" 2>/dev/null || echo "   Нет тегов"
        fi
    fi
    
    move_file "$file" "mp3_files"
}

process_html_file() {
    local file="$1"
    echo "🌐 HTML документ: $(basename "$file")"
    
    if [ "$DRY_RUN" = true ]; then
        echo "   🔍 [dry-run] Будет проверен DOCTYPE"
    else
        if head -5 "$file" 2>/dev/null | grep -i doctype >/dev/null; then
            echo "   ✅ DOCTYPE найден"
        else
            echo "   ⚠️  DOCTYPE не найден"
        fi
    fi
    
    move_file "$file" "html_files"
}

process_unknown_file() {
    local file="$1"
    echo "❓ Неизвестный тип: $(basename "$file")"
    
    if [ "$DRY_RUN" = true ]; then
        echo "   🔍 [dry-run] Будет определён тип файла"
    else
        if command -v file >/dev/null 2>&1; then
            file "$file" | cut -d: -f2- | sed 's/^/   /'
        fi
    fi
    
    # Неизвестные файлы перемещаем в отдельную папку
    move_file "$file" "other_files"
}

# ===== ОСНОВНОЙ ЦИКЛ =====
echo "📁 Начинаем обработку файлов..."
echo "===================================="

count=0
moved_count=0

# Проходим по всем файлам в текущей директории
for file in *; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        extension="${filename##*.}"
        
        # Если нет расширения
        if [ "$filename" = "$extension" ]; then
            extension="no_extension"
        fi
        
        # Приводим к нижнему регистру
        extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')
        
        # Выбираем функцию по расширению
        case "$extension" in
            txt)        process_txt_file "$file" ;;
            pdf)        process_pdf_file "$file" ;;
            jpg|jpeg)   process_jpg_file "$file" ;;
            png)        process_png_file "$file" ;;
            sh)         process_sh_file "$file" ;;
            zip)        process_zip_file "$file" ;;
            mp3)        process_mp3_file "$file" ;;
            html|htm)   process_html_file "$file" ;;
            *)          process_unknown_file "$file" ;;
        esac
        
        echo "----------------------------------------"
        ((count++))
    fi
done

# ===== ИТОГОВЫЙ ОТЧЕТ =====
echo ""
echo "===================================="
echo "✅ ОБРАБОТКА ЗАВЕРШЕНА!"
echo "===================================="
echo "📊 Статистика:"
echo "   Всего обработано файлов: $count"

if [ "$MOVE_FILES" = true ]; then
    if [ "$DRY_RUN" = true ]; then
        echo "   🔍 Режим: ПРОБНЫЙ ЗАПУСК (ничего не перемещено)"
    else
        echo "   📦 Режим: ПЕРЕМЕЩЕНИЕ ФАЙЛОВ"
        echo ""
        echo "📁 Созданные папки:"
        ls -d */ 2>/dev/null | sed 's/^/   /' || echo "   Папки не создавались"
    fi
else
    echo "   ℹ️  Режим: ТОЛЬКО ПРОСМОТР (файлы не перемещались)"
    echo "   💡 Используйте опцию --move для перемещения файлов"
fi

echo "===================================="
