# language: ru

Функционал: Синхронизация хранилища конфигурации 1С и гит (команды sync)
    Как Пользователь
    Я хочу выполнять автоматическую синхронизацию конфигурации из хранилища
    Чтобы автоматизировать свою работы с хранилищем с git

Контекст: Тестовый контекст синхронизации
    Когда Я устанавливаю рабочей каталог во временный каталог
    И Я создаю новый объект ГитРепозиторий
    И Я создаю новый объект МенеджерСинхронизации
    И Я создаю временный каталог и сохраняю его в контекст
    И я скопировал каталог тестового хранилища конфигурации во временный каталог
    И Я сохраняю значение временного каталога в переменной "КаталогХранилища1С"
    И Я создаю временный каталог и сохраняю его в контекст
    И Я сохраняю значение временного каталога в переменной "ПутьКаталогаИсходников"
    И Я инициализирую репозиторий в каталоге из переменной "ПутьКаталогаИсходников"
    И Я создаю тестовой файл AUTHORS 
    И Я записываю "0" в файл VERSION
    И Я включаю отладку лога с именем "oscript.app.gitsync.plugins.loader"
    И Я включаю отладку лога с именем "oscript.app.gitsync.plugins.event-subscriptions"
# Сценарий: Простая синхронизация хранилища с git-репозиторием
#     Допустим Я устанавливаю авторизацию в хранилище пользователя "Администратор" с паролем ""
#     И Я устанавливаю версию платформы "8.3"
#     Когда Я выполняю выполняют синхронизацию
#     Тогда Вывод лога содержит "Завершена синхронизации с git"

Сценарий: Cинхронизация хранилища с git-репозиторием c плагинами
    Допустим Я устанавливаю авторизацию в хранилище пользователя "Администратор" с паролем ""
    И Я устанавливаю версию платформы "8.3"
    И Я создаю временный каталог и сохраняю его в переменной "КаталогПлагинов"
    И Я создаю новый УправлениеПлагинами
    И Я собираю тестовый плагин в каталоге из переменной "КаталогПлагинов"
    И Я загружаю плагины из каталога в переменной "КаталогПлагинов"
    И Я подключаю плагины в МенеджерСинхронизации
    Когда Я выполняю выполняют синхронизацию
    Тогда Вывод лога содержит "Завершена синхронизации с git"
    