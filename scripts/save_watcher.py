"""
Dragon Age: Origins & Awakening — Live Save File Auto-Watcher
-------------------------------------------------------------
Этот скрипт отслеживает появление новых файлов сохранений (при быстром сохранении F5 или автосохранении)
в папке 'Документы/BioWare/Dragon Age/Characters' и выводит актуальный статус персонажа в реальном времени.

Запуск:
  python scripts/save_watcher.py
"""

import os
import time
import glob
import sys

def get_default_save_path():
    user_profile = os.environ.get('USERPROFILE', '')
    docs_path = os.path.join(user_profile, 'Documents', 'BioWare', 'Dragon Age', 'Characters')
    return docs_path

def find_latest_save(characters_dir):
    pattern = os.path.join(characters_dir, '**', 'Saves', '**', '*.das')
    saves = glob.glob(pattern, recursive=True)
    if not saves:
        return None
    saves.sort(key=os.path.getmtime, reverse=True)
    return saves[0]

def main():
    save_dir = get_default_save_path()
    print("=" * 60)
    print("⚔️ DRAGON AGE ORIGINS & AWAKENING — LIVE SAVE WATCHER ⚔️")
    print("=" * 60)
    print(f"📁 Папка поиска сохранений: {save_dir}")

    if not os.path.exists(save_dir):
        print(f"⚠️ Папка сохранений пока не найдена. Убедитесь, что игра Dragon Age запускалась на этом ПК.")
        print(f"Путь: {save_dir}")

    last_processed_file = None
    last_mtime = 0

    print("\n🟢 Авто-сканирование активно! Сохранитесь в игре (F5), чтобы увидеть статус...\n")

    try:
        while True:
            latest = find_latest_save(save_dir)
            if latest:
                mtime = os.path.getmtime(latest)
                if latest != last_processed_file or mtime > last_mtime:
                    last_processed_file = latest
                    last_mtime = mtime
                    file_size = os.path.getsize(latest)
                    print(f"✨ [ОБНАРУЖЕНО СОХРАНЕНИЕ] -> {os.path.basename(latest)}")
                    print(f"   📂 Путь: {latest}")
                    print(f"   📊 Размер: {file_size / 1024:.1f} KB | Время: {time.strftime('%H:%M:%S', time.localtime(mtime))}")
                    print(f"   💡 Перетащите этот файл в веб-приложение для мгновенного анализа!\n")
            time.sleep(2.0)
    except KeyboardInterrupt:
        print("\n🛑 Сканирование остановлено пользователем.")

if __name__ == '__main__':
    main()
