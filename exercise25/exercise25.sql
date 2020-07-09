#1. Tworzy tabelę pracownik(imie, nazwisko, wyplata, data urodzenia, stanowisko). W tabeli mogą być dodatkowe kolumny, które uznasz za niezbędne.

CREATE TABLE pracownik(
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
	imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    wyplata DECIMAL(15,2),
	data_urodzenia DATE,
    stanowisko VARCHAR(50));

#2.Wstawia do tabeli co najmniej 6 pracowników

INSERT INTO pracownik(imie, nazwisko, wyplata, data_urodzenia, stanowisko) 
VALUES('Tom', 'Cruise', 99999.99, '2000-05-15', 'Aktor'),
('Krzysztof', 'Bosak', 9999.99, '1990-07-08', 'Polityk'),
('Andrzej', 'Gołota', 40123, '1980-05-15', 'Bokser'),
('Zupełnie', 'Nikt', 44999.99, '1700-05-15', 'Nikt'),
('Mikołaj', 'Kopernik', 99999.99, '1473-01-19', 'Celebryta'),
('Anna', 'Zaporowska', 5678.50, '1990-07-07', 'Spawacz');

#3.Pobiera wszystkich pracowników i wyświetla ich w kolejności alfabetycznej po nazwisku

SELECT * from pracownik ORDER BY nazwisko;

#4.Pobiera pracowników na wybranym stanowisku

SELECT * from pracownik WHERE stanowisko LIKE 'Polityk';

#5.Pobiera pracowników, którzy mają co najmniej 30 lat

SELECT *, TIMESTAMPDIFF(YEAR, data_urodzenia, NOW()) AS roznica_lat_od_dzisiaj FROM pracownik WHERE (TIMESTAMPDIFF(YEAR, data_urodzenia, NOW()) >= 30);

#6.Zwiększa wypłatę pracowników na wybranym stanowisku o 10%

SET SQL_SAFE_UPDATES = 0;
UPDATE pracownik SET wyplata=wyplata*1.1 WHERE stanowisko LIKE 'Polityk';

#7.Usuwa najmłodszego pracownika

DELETE FROM pracownik WHERE data_urodzenia IS NOT NULL ORDER BY data_urodzenia DESC LIMIT 1;

#8.Usuwa tabelę pracownik

DROP TABLE pracownik;

#9.Tworzy tabelę stanowisko (nazwa stanowiska, opis, wypłata na danym stanowisku)

CREATE TABLE stanowisko(
id BIGINT PRIMARY KEY AUTO_INCREMENT,
nazwa VARCHAR(50),
opis TINYTEXT,
wyplata DECIMAL(15,2));

#10.Tworzy tabelę adres (ulica+numer domu/mieszkania, kod pocztowy, miejscowość)

CREATE TABLE adres(
id BIGINT PRIMARY KEY AUTO_INCREMENT,
ulica_i_numer_domu_lub_mieszkania VARCHAR(100),
kod_pocztowy CHAR(5),
miejscowosc VARCHAR(50));

#11.Tworzy tabelę pracownik (imię, nazwisko) + relacje do tabeli stanowisko i adres

CREATE TABLE pracownik(
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
	imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    stanowisko_id BIGINT NOT NULL,
    adres_id BIGINT NOT NULL,
    FOREIGN KEY(stanowisko_id) REFERENCES stanowisko(id),
    FOREIGN KEY(adres_id) REFERENCES adres(id));
    
#12.Dodaje dane testowe (w taki sposób, aby powstały pomiędzy nimi sensowne powiązania)

INSERT INTO stanowisko(nazwa, opis, wyplata)
VALUES('Developer', 'Jakis tam opis', 10000),
('Astronom', 'Istny kosmos', 25000),
('Celebryta', 'Bzdury', 1000);

INSERT INTO adres(ulica_i_numer_domu_lub_mieszkania, kod_pocztowy, miejscowosc)
VALUES('Vivaldiego 99/99', '52129', 'Wrocław'),
('Beethovena 777/7', '52129', 'Gdańsk'),
('Vasco da Gama', '51502', 'Opole');


INSERT INTO pracownik(imie, nazwisko, stanowisko_id, adres_id)
VALUES('Tom', 'Cruise', 1, 2),
('Mikołaj', 'Kopernik', 2, 3),
('Andrzej', 'Gołota', 3, 1),
('Mr', 'Who', 1, 2);

#13.Pobiera pełne informacje o pracowniku (imię, nazwisko, adres, stanowisko)

SELECT p.imie, p.nazwisko, s.nazwa AS stanowisko, a.ulica_i_numer_domu_lub_mieszkania AS adres, a.miejscowosc AS miasto, a.kod_pocztowy AS kod
FROM pracownik p 
INNER JOIN stanowisko s ON p.stanowisko_id = s.id
INNER JOIN adres a ON p.adres_id = a.id;

#14.Oblicza sumę wypłat dla wszystkich pracowników w firmie

SELECT SUM(s.wyplata)
FROM pracownik p
INNER JOIN stanowisko s ON p.stanowisko_id = s.id;

#15.Pobiera pracowników mieszkających w lokalizacji z kodem pocztowym 90210 (albo innym, który będzie miał sens dla Twoich danych testowych)

SELECT p.imie, p.nazwisko, a.kod_pocztowy
FROM pracownik p
INNER JOIN adres a ON p.adres_id = a.id AND a.kod_pocztowy LIKE '51502';