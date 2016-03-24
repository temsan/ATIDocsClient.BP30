﻿
&НаКлиенте
Перем API;

&НаКлиенте
Перем Служебный;

////////////////////////////////////////////////////////////////////////////////
// ЛОГИКА ФОРМЫ НА СТОРОНЕ КЛИЕНТА

&НаКлиенте
Процедура ПолучитьДокументыПоКонтрагенту()

	//Документы.Очистить();
	
	Попытка
		
		Соединение = Новый HTTPСоединение("ati.su");
		ЗаголовкиHTTP = Новый Соответствие();
		ЗаголовкиHTTP.Вставить("Accept", "text/html");
		Запрос = Новый HTTPЗапрос("/Tables/Info.aspx?ID="+Формат(id, "ЧГ=0"), ЗаголовкиHTTP);
		Ответ = Соединение.Получить(Запрос);
		ОтветСтрокой = Ответ.ПолучитьТелоКакСтроку();
		//Сообщить();
		
		
		ЧтениеHTML = Новый ЧтениеHTML;
		ЧтениеHTML.УстановитьСтроку(ОтветСтрокой);
		
		ПостроительDOM = Новый ПостроительDOM;
		ДокументHTML = ПостроительDOM.Прочитать(ЧтениеHTML);
		ЭлементыDOM = ДокументHTML.ПолучитьЭлементыПоИмени("li");
		Для Каждого ЭлементDOM Из ЭлементыDOM Цикл
			ЭлементыДокумент = ЭлементDOM.ПолучитьЭлементыПоИмени("a");
			Для Каждого ЭлементДокумент Из ЭлементыДокумент Цикл
				СтрДокумент = Документы.Добавить();
				СтрДокумент.Описание = СокрЛП(ЭлементДокумент.ТекстовоеСодержимое);
				СтрДокумент.Ссылка = СокрЛП(ЭлементДокумент.Гиперссылка);
			КонецЦикла;
		КонецЦикла;
		
		Рейтинг = ДокументHTML.ПолучитьЭлементПоИдентификатору("ctlStarReliability_ctlStarControl").Атрибуты[1].Значение;
		
	Исключение
	КонецПопытки;

КонецПроцедуры 


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СТАНДАРТНЫХ СОБЫТИЙ НА СТОРОНЕ СЕРВЕРА 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ID = Параметры.ID;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СТАНДАРТНЫХ СОБЫТИЙ НА СТОРОНЕ КЛИЕНТА

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	API = ВладелецФормы.API;
	Служебный = ВладелецФормы.Служебный;
	
	ПутьКФормам = ВладелецФормы.ПутьКФормам;
	
	Результат1С = API.Account(ID);
	
	Если Результат1С = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИнформацияОКонтрагенте = Служебный.СформироватьИнформациюОбАккаунте(Результат1С);
	Заголовок = Результат1С["name"];	
	
	Контакты.Очистить();
	
	Для Каждого Элемент Из Результат1С["contacts"] Цикл
		
		СтрКонтакт = Контакты.Добавить();
		
		Если ТипЗнч(Элемент) = Тип("КлючИЗначение") Тогда
			Контакт = Элемент.Значение;
		Иначе
			Контакт = Элемент;
		КонецЕсли;
		
		СтрКонтакт.Имя = СокрЛП(Контакт.Получить("name"));
		
		СтрКонтакт.ТелефонМобильный = Контакт.Получить("mobile");
		СтрКонтакт.Телефон = Контакт.Получить("phone");
		СтрКонтакт.Факс = Контакт.Получить("fax");
		СтрКонтакт.Email = Контакт.Получить("email");
		
	КонецЦикла;
	
	ПолучитьДокументыПоКонтрагенту();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ НА СТОРОНЕ КЛИЕНТА 

&НаКлиенте
Процедура КомандаСоздатьДокумент(Команда)
	
	ОткрытьФорму(ПутьКФормам + "ФормаДокумента", Новый Структура("КонтрагентId", ID), ВладелецФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаКарточкаATI(Команда)
	
	url = "http://www.ati.su/Tables/Info.aspx?ID="+Формат(id, "ЧГ=0");
	ЗапуститьПриложение(url);
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеДействияФормыРазоваяЗаявка(Команда)
	Форма = ПолучитьФорму("РазоваяЗаявка");
	СтруктураДанных = Форма.ОткрытьМодально();
КонецПроцедуры

&НаКлиенте
Процедура НайтиДокументы(Команда)
	
	СтруктураПапок = API.MailBox();
	
	ДокументыАТИ_Доки.Очистить();
	
	Для Каждого Папка Из СтруктураПапок Цикл
		Если Папка.Ключ = "documents" Тогда
			КоличествоДокументов = Папка.Значение[0];
			
			Маска = """ati_id"": """+Формат(id, "ЧГ=0")+"""";
			//Маска = """"+Формат(id, "ЧГ=0")+"""";
			
			Для Н = 1 По КоличествоДокументов Цикл
				
				ДокументН = API.Documents("documents", Н-1, 1, Маска);
				Если ДокументН <> Неопределено Тогда
					СтрДокументыАТИ_Доки = ДокументыАТИ_Доки.Добавить();
					СтрДокументыАТИ_Доки.ID = ДокументН[0]["id"];
				КонецЕсли;
				
			КонецЦикла;
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ДокументыАТИ_Доки.Количество() = 0 Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "С данным контрагентом у вас нет ЭДО.
		|По вашему запросу нечего не найдено";
		Сообщение.Поле = "ДокументыАТИ_Доки"; //имя реквизита 
		Сообщение.Сообщить();
		
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ НА СТОРОНЕ КЛИЕНТА

&НаКлиенте
Процедура ПанельПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если Элементы.Панель.ТекущаяСтраница = Элементы.Панель.Страницы.WebСтраница Тогда
		Попытка
			Элементы.ПолеHTMLДокумента.Перейти("http://www.ati.su/Tables/Info.aspx?ID="+Формат(id, "ЧГ=0"));
		Исключение
			Сообщить("Ошибка");
		КонецПопытки;
	ИначеЕсли Элементы.Панель.ТекущаяСтраница = Элементы.Панель.Страницы.Документы Тогда
		Попытка
			ПолучитьДокументыПоКонтрагенту();
			
		Исключение
			Сообщить("Ошибка");
		КонецПопытки;
	ИначеЕсли Элементы.Панель.ТекущаяСтраница = Элементы.Панель.Страницы.АТИ_Доки Тогда
		//костыль. ждем доработку АПИ
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ТестНажатие(Элемент)
	Сообщить(Элементы.ПолеHTMLДокумента.ПолучитьТекст());
КонецПроцедуры

&НаКлиенте
Процедура ДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекДанные = Элементы.Документы.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекДанные.Ссылка) Тогда
		ЗапуститьПриложение(ТекДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекДанные = Элементы.Контакты.ТекущиеДанные;
	Если Поле.Имя = "КонтактыEmail" И ЗначениеЗаполнено(ТекДанные.email) Тогда
		СтандартнаяОбработка = Ложь;
		ЗапуститьПриложение("mailto:"+ТекДанные.email);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыАТИ_ДокиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекДанные = Элемент.ТекущиеДанные;
	
	Если ТекДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ID", ТекДанные.ID);
	
	ФормаДокумента = ОткрытьФорму(ПутьКФормам + "ФормаДокумента", ПараметрыФормы, ВладелецФормы);
	
КонецПроцедуры




