﻿
Перем ТипыТранспорта Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЛОГИКА ФОРМЫ НА СТОРОНЕ СЕРВЕРА



////////////////////////////////////////////////////////////////////////////////
// ЛОГИКА ФОРМЫ НА СТОРОНЕ КЛИЕНТА



////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СТАНДАРТНЫХ СОБЫТИЙ НА СТОРОНЕ СЕРВЕРА 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьТипыРеквизитов();
	ЗаполнитьСпискиВыбора();
	
	Контрагент = Параметры.Контрагент;
	
	ЧастиАдреса = УправлениеКонтактнойИнформациейСлужебный.СписокРеквизитовНаселенныйПункт( , "ФИАС");
	
	СписокТаблиц = Новый Структура(
		"ТочкиМаршрута,
		|Грузы,
		|Транспорт,
		|Водители,
		|ГрафикОплаты");

	Если ЗначениеЗаполнено(Параметры.ФайлИмя) Тогда
		ЗаполнитьИзФайла(Параметры.ФайлИмя);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ID) Тогда
		ДатаДокумента = ТекущаяДата();
	КонецЕсли;

	УправлениеВидимостьюДоступностьюЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьТипыРеквизитов();
	
	//Для каждого ИмяТаблицы Из СписокТаблиц Цикл
	//	
	//	ТаблицаТЗ = Настройки.Получить(ИмяТаблицы.Ключ);
	//	
	//	Если ТаблицаТЗ <> Неопределено Тогда
	//		ЭтотОбъект[ИмяТаблицы.Ключ].Загрузить(ТаблицаТЗ);
	//	КонецЕсли;
	//	
	//КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	//Для каждого ИмяТаблицы Из СписокТаблиц Цикл
	//	Настройки.Вставить(ИмяТаблицы.Ключ, ЭтотОбъект[ИмяТаблицы].Выгрузить());
	//КонецЦикла;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СТАНДАРТНЫХ СОБЫТИЙ НА СТОРОНЕ КЛИЕНТА


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПутьКФормам = ВладелецФормы.ПутьКФормам;
		
		
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ НА СТОРОНЕ КЛИЕНТА 

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Закрыть(СтруктураДанных);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПечать(Команда)
	
	//Сообщить("Sorry, service is under constuction..");
	
	
	//ТабДок = ПечатьЗаявкиНаПеревозку(ЭтаФорма); //Переделать на структуру 
	
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ НА СТОРОНЕ КЛИЕНТА









