#Использовать logos

Перем Лог;

#Область Подписки_на_события

Процедура ПриАктивизации(ОбъектПодписки) Экспорт

	Лог.Информация("Вызван событие <ПриАктивизации> для плагина <%1>", Имя());
	
КонецПроцедуры

#КонецОбласти

#Область Интерфейс_плагина

Функция Версия() Экспорт
	Возврат "0.0.1";
КонецФункции

Функция Описание() Экспорт
	Возврат "Тестовый плагин";
КонецФункции

Функция Справка() Экспорт
	Возврат "Справка плагина";
КонецФункции

Функция Имя() Экспорт
	Возврат "test_plugin";
КонецФункции

Функция ИмяЛога() Экспорт
	Возврат "oscript.lib.gitsync.test_plugin";
КонецФункции

#КонецОбласти

Лог = Логирование.ПолучитьЛог(ИмяЛога());

