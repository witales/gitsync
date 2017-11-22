
#Использовать logos

Перем ВерсияПлагина;
Перем Лог;
Перем КомандыПлагина;
Перем МассивНомеровВерсий;
Перем Лимит;
Перем Обработчик;
Перем НачальнаяВерсия;
Перем КонечнаяВерсия;

Функция Информация() Экспорт
	
	Возврат Новый Структура("Версия, Лог", ВерсияПлагина, Лог)
	
КонецФункции // Информация() Экспорт

Процедура ПриАктивизацииПлагина(СтандартныйОбработчик) Экспорт
	
	Обработчик = СтандартныйОбработчик;

КонецПроцедуры

Процедура ПриРегистрацииКомандыПриложения(ИмяКоманды, КлассРеализации, Парсер) Экспорт

	Лог.Отладка("Ищю команду <%1> в списке поддерживаемых", ИмяКоманды);
	Если КомандыПлагина.Найти(ИмяКоманды) = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Лог.Отладка("Устанавливаю дополнительные параметры для команды %1", ИмяКоманды);
	
	ОписаниеКоманды = Парсер.ПолучитьКоманду(ИмяКоманды);
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-limit", "[PLUGIN] [limit] выгрузить не более <Количества> версий от текущей выгруженной");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-minversion", "[PLUGIN] [limit] <номер> минимальной версии для выгрузки");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "-maxversion", "[PLUGIN] [limit] <номер> максимальной версии для выгрузки");

	Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры

Процедура ПриВыполненииКоманды(ПараметрыКоманды, ДополнительныеПараметры) Экспорт
	
	Лимит = ПараметрыКоманды["-limit"];
	НачальнаяВерсия = ПараметрыКоманды["-minversion"];
	КонечнаяВерсия = ПараметрыКоманды["-maxversion"];

	Если Лимит = Неопределено Тогда
		Лимит = 0;
	КонецЕсли;
	
	Если НачальнаяВерсия = Неопределено Тогда
		НачальнаяВерсия = 0;
	КонецЕсли;	
	
	Если КонечнаяВерсия = Неопределено Тогда
		КонечнаяВерсия = 0;
	КонецЕсли;

	
	Лимит = Число(Лимит);
	НачальнаяВерсия = Число(НачальнаяВерсия);
	КонечнаяВерсия = Число(КонечнаяВерсия);
	
	Лог.Отладка("Установлен лимит <%1> выгрузки версий", Лимит);
	Лог.Отладка("Установлена начальная версия <%1> выгрузки версий", НачальнаяВерсия);
	Лог.Отладка("Установлена конечная версия <%1> выгрузки версий", КонечнаяВерсия);
	
КонецПроцедуры

Процедура ПередНачаломЦиклаОбработкиВерсий(ТаблицаИсторииХранилища, ТекущаяВерсия, СледующаяВерсия, МаксимальнаяВерсияДляРазбора) Экспорт 

	Если НачальнаяВерсия > 0 Тогда
		СледующаяВерсия = Макс(НачальнаяВерсия, СледующаяВерсия);
	КонецЕсли;

	Если Лимит > 0 Тогда
		
		СтрокаТекущейВерсии = ТаблицаИсторииХранилища.Найти(ТекущаяВерсия, "НомерВерсии");
		ИндексСтрокиТекущейВерсии = ТаблицаИсторииХранилища.Индекс(СтрокаТекущейВерсии);
		ИндексСтрокиСОграничением = Мин(ТаблицаИсторииХранилища.Количество() - 1, ИндексСтрокиТекущейВерсии + Лимит);
		НомерВерсииСогласноЛимита = ТаблицаИсторииХранилища[ИндексСтрокиСОграничением].НомерВерсии;
		
		Если КонечнаяВерсия = 0 Тогда
			КонечнаяВерсия = НомерВерсииСогласноЛимита;
		Иначе
			КонечнаяВерсия = ?(КонечнаяВерсия >= НомерВерсииСогласноЛимита, КонечнаяВерсия, НомерВерсииСогласноЛимита);
		КонецЕсли;
		
	КонецЕсли;

	МаксимальнаяВерсияДляРазбора = ОпределитьМаксимальнуюВерсиюСУчетомОграниченияСверху(ТаблицаИсторииХранилища, ТекущаяВерсия, КонечнаяВерсия);

КонецПроцедуры


Функция ОпределитьМаксимальнуюВерсиюСУчетомОграниченияСверху(Знач ТаблицаИсторииХранилища, Знач ТекущаяВерсия, Знач МаксимальнаяВерсия)
	
	МаксимальнаяВерсияДляРазбора = 0;
	ЧислоВерсийПлюс = 0;

	Если МаксимальнаяВерсия <> 0 Тогда
		Попытка
			МаксимальнаяВерсия = Число(МаксимальнаяВерсия);
		Исключение
			МаксимальнаяВерсия = 0;
		КонецПопытки;
	КонецЕсли;

	МаксВерсияВХранилище = ОпределитьМаксимальнуюВерсиюВХранилище(ТаблицаИсторииХранилища);

	Если МаксимальнаяВерсия > 0 Тогда
		МаксимальнаяВерсияДляРазбора = Мин(МаксВерсияВХранилище, МаксимальнаяВерсия) ;
	Иначе
		МаксимальнаяВерсияДляРазбора = МаксВерсияВХранилище;
	КонецЕсли;

	Возврат МаксимальнаяВерсияДляРазбора;

КонецФункции

Функция ОпределитьМаксимальнуюВерсиюВХранилище(Знач ТаблицаИсторииХранилища)

	Если ТаблицаИсторииХранилища.Количество() = 0 Тогда
		Возврат 0;
	КонецЕсли;

	МаксимальнаяВерсия = Число(ТаблицаИсторииХранилища[0].НомерВерсии);
	Для Сч = 1 По ТаблицаИсторииХранилища.Количество()-1 Цикл
		ЧислоВерсии = Число(ТаблицаИсторииХранилища[Сч].НомерВерсии);
		Если ЧислоВерсии > МаксимальнаяВерсия Тогда
			МаксимальнаяВерсия = ЧислоВерсии;
		КонецЕсли;
	КонецЦикла;

	Возврат МаксимальнаяВерсия;

КонецФункции

Функция Форматировать(Знач Уровень, Знач Сообщение) Экспорт
	
	Возврат СтрШаблон("[PLUGIN] %1: %2 - %3", ИмяПлагина(), УровниЛога.НаименованиеУровня(Уровень), Сообщение);
	
КонецФункции

// Выполняет обновление конфигурации из хранилища, выгрузку конфигурации в файлы
// и распределение файлов по каталогам согласно иерархии метаданных.
//
Процедура РазобратьФайлКонфигурацииШтатнымиСредствами(Знач ПутьКХранилищу, Знач НомерВерсии, Знач ПараметрыДоступаКХранилищу, Знач ВыходнойКаталог, Знач Формат) Экспорт
	
	КаталогПлоскойВыгрузки = ВременныеФайлы.СоздатьКаталог();

	Если Не (Новый Файл(ВыходнойКаталог).Существует()) Тогда
		СоздатьКаталог(ВыходнойКаталог);
	КонецЕсли;

	КаталогВыгрузки = ?(ТолькоИзменения, ВыходнойКаталог, КаталогПлоскойВыгрузки);
	Попытка
		ВыгрузитьМодулиКонфигурацииОбновлениеИзХранилища(ПутьКХранилищу, НомерВерсии, ПараметрыДоступаКХранилищу, КаталогПлоскойВыгрузки, Формат);
		Если НЕ ТолькоИзменения Тогда
			//РазложитьМодули1СПоПапкамСогласноИерархииМетаданных(КаталогПлоскойВыгрузки, ВыходнойКаталог, Формат);
		Иначе
			МассивФайлов = НайтиФайлы(КаталогВыгрузки, "*.bin", Истина);
			Для каждого Файл из МассивФайлов Цикл
				Если Нрег(Файл.Имя) = "form.bin" Тогда
					КаталогФормы = ОбъединитьПути(Файл.Путь, Файл.ИмяБезРасширения);
					СоздатьКаталог(КаталогФормы);
					ФС.ОбеспечитьПустойКаталог(КаталогФормы);
					РаспаковатьКонтейнерМетаданных(Файл.ПолноеИмя, КаталогФормы);
				КонецЕсли;
			КонецЦикла;

			Если Новый Файл(ОбъединитьПути(КаталогВыгрузки, "renames.txt")).Существует() Тогда
				УдалитьВременныеФайлыПриНеобходимости(ОбъединитьПути(КаталогВыгрузки, "renames.txt"));
			КонецЕсли;

		КонецЕсли;
	Исключение
		УдалитьВременныеФайлыПриНеобходимости(КаталогПлоскойВыгрузки);
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры


// Выполняет штатную выгрузку конфигурации в файлы (средствами платформы 8.3) без загрузки конфигурации, но с обновлением на версию хранилища
//
Процедура ВыгрузитьМодулиКонфигурацииОбновлениеИзХранилища(Знач ПутьКХранилищу, Знач НомерВерсии, Знач ПараметрыДоступаКХранилищу, Знач КаталогПлоскойВыгрузки, Знач Формат) Экспорт
	
	Конфигуратор = ПолучитьМенеджерКонфигуратора();
	Если ВерсияПлатформы <> Неопределено Тогда
		Конфигуратор.ИспользоватьВерсиюПлатформы(ВерсияПлатформы);
	Иначе
		Конфигуратор.ИспользоватьВерсиюПлатформы("8.3");
	КонецЕсли;

	ЛогКонфигуратора = Логирование.ПолучитьЛог("oscript.lib.v8runner");
	ЛогКонфигуратора.УстановитьУровень(Лог.Уровень());
	
	ПользовательХранилища = ПараметрыДоступаКХранилищу.ПользовательХранилища;
	ПарольХранилища		  = ПараметрыДоступаКХранилищу.ПарольХранилища;

	Попытка

		ПараметрыЗапуска = Конфигуратор.ПолучитьПараметрыЗапуска();
		ПараметрыЗапуска.Добавить("/ConfigurationRepositoryUpdateCfg");
		ПараметрыЗапуска.Добавить("/ConfigurationRepositoryF """+ПутьКХранилищу+"""");
		
		ПараметрыЗапуска.Добавить("/ConfigurationRepositoryN """+ПользовательХранилища+"""");
		
		Если Не ПустаяСтрока(ПарольХранилища) Тогда
			ПараметрыЗапуска.Добавить("/ConfigurationRepositoryP """+ПарольХранилища+"""");
		КонецЕсли;

		ПараметрыЗапуска.Добавить("-v "+НомерВерсии);
		
		ПараметрыЗапуска.Добавить("-force");
		
		ВыполнитьКомандуКонфигуратора(Конфигуратор, ПараметрыЗапуска);

		//Конфигуратор.ОбновитьКонфигурациюБазыДанныхИзХранилищаНаВерсию(ПутьКХранилищу, ПользовательХранилища, ПарольХранилища, НомерВерсии);

	Исключение
		
		ТекстОшибки = Конфигуратор.ВыводКоманды();
		ВызватьИсключение ТекстОшибки;

	КонецПопытки;

	Если Не (Новый Файл(КаталогПлоскойВыгрузки).Существует()) Тогда
		СоздатьКаталог(КаталогПлоскойВыгрузки);
	КонецЕсли;

	МассивФайлов = НайтиФайлы(КаталогПлоскойВыгрузки, ПолучитьМаскуВсеФайлы());
	Если МассивФайлов.Количество() <> 0 Тогда
		ВызватьИсключение "В каталоге <"+КаталогПлоскойВыгрузки+"> не должно быть файлов";
	КонецЕсли;

	Конфигуратор.ВыгрузитьКонфигурациюВФайлы(КаталогПлоскойВыгрузки, Формат);
	//ВыполнитьКомандуКонфигуратора(Конфигуратор, ПараметрыЗапуска);

КонецПроцедуры

// Устанавливает параметры авторизации в хранилище 1С, если выгрузка версии выполняется средствами платформы
//
Процедура УстановитьАвторизациюВХранилищеКонфигурации(Знач Логин, Знач Пароль, Знач ВерсияПлатформы = "")
	
		мАвторизацияВХранилищеСредствами1С = Новый Структура;
		мАвторизацияВХранилищеСредствами1С.Вставить("Логин" , Логин);
		мАвторизацияВХранилищеСредствами1С.Вставить("Пароль", Пароль);
		мАвторизацияВХранилищеСредствами1С.Вставить("ВерсияПлатформы", ВерсияПлатформы);
	
	КонецПроцедуры
	


Процедура ПроверитьПараметрыДоступаКХранилищу(ПараметрыДоступаКХранилищу) Экспорт
	
	Если ПараметрыДоступаКХранилищу.ПользовательХранилища = Неопределено Тогда
		
		ВызватьИсключение "Не задан пользователь хранилища конфигурации.";
		
	КонецЕсли;
	
	Если ПараметрыДоступаКХранилищу.ПарольХранилища = Неопределено Тогда
	
		ПарольХранилища = "";
		
	КонецЕсли;
	
КонецПроцедуры // ПроверитьПараметрыДоступаКХранилищу



Функция ИмяПлагина()
	возврат "useVendorUpload";
КонецФункции // ИмяПлагина()

Процедура Инициализация()

	ВерсияПлагина = "1.0.0";
	Лог = Логирование.ПолучитьЛог("oscript.app.gitsync.plugins."+ ИмяПлагина());
	КомандыПлагина = Новый Массив;
	КомандыПлагина.Добавить("sync");
	КомандыПлагина.Добавить("export");
	Лимит = 0;
	КонечнаяВерсия = 0;
	НачальнаяВерсия = 0;
	Лог.УстановитьРаскладку(ЭтотОбъект);

КонецПроцедуры

Инициализация();


