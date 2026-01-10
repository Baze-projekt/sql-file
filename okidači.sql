DROP DATABASE formula;
CREATE DATABASE formula;

USE formula;


CREATE TABLE tim (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(100) NOT NULL UNIQUE,
    vlasnik VARCHAR(100),
    baza VARCHAR(100),
	drzava VARCHAR(50) NOT NULL,
    budzet DECIMAL(15,2) NOT NULL DEFAULT 0
);


CREATE TABLE bolid (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_tim INT NOT NULL,
    model VARCHAR(100) NOT NULL,
    godina INT NOT NULL,
    motor VARCHAR(100),
    sasija VARCHAR(100),
    stanje VARCHAR(30) DEFAULT 'Ispravan',
    FOREIGN KEY (id_tim) REFERENCES tim(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE vozac (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_tim INT NOT NULL,
    ime VARCHAR(100) NOT NULL,
    prezime VARCHAR(100) NOT NULL,
    broj INT NOT NULL,
    nacionalnost VARCHAR(100),
    datum_rodjenja DATE,
    slika LONGBLOB,
    FOREIGN KEY (id_tim) REFERENCES tim(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT uniq_broj_tim UNIQUE(id_tim, broj)
);
CREATE TABLE vozac_bolid (
	id INT AUTO_INCREMENT PRIMARY KEY,
	id_bolid INT NOT NULL,
    id_vozac INT NOT NULL,
    godina INT NOT NULL,
	FOREIGN KEY (id_bolid) REFERENCES bolid(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (id_vozac) REFERENCES vozac(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
CREATE TABLE staza (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(100) NOT NULL UNIQUE,
    lokacija VARCHAR(100),
    drzava VARCHAR(100),
    duljina_km DECIMAL(5,2),
    broj_krugova INT CHECK (broj_krugova > 0)
);

CREATE TABLE sezona ( #specifično 2025
	id INT AUTO_INCREMENT PRIMARY KEY,
    godina YEAR NOT NULL,
    datum_pocetka DATE,
    datum_zavrsetka DATE
 );


CREATE TABLE utrka (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(100),
    id_staza INT NOT NULL, #gdje
    id_sezona INT NOT NULL, #ime natjecanja
    datum DATE,
	status ENUM('Traje','Zavrsena') DEFAULT "Traje",
    FOREIGN KEY (id_staza) REFERENCES staza(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (id_sezona) REFERENCES sezona(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
	
);

CREATE TABLE sudjelovanje (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_utrka INT NOT NULL,
    id_vozac_bolid INT ,
    FOREIGN KEY (id_utrka) REFERENCES utrka(id),
    FOREIGN KEY (id_vozac_bolid) REFERENCES vozac_bolid(id),
    UNIQUE(id_utrka, id_vozac_bolid)
);


CREATE TABLE rezultat (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_utrka INT NOT NULL, #koja utrka
	id_vozac_bolid INT NOT NULL, #tko je pobijedio
    vrijeme TIME,
    FOREIGN KEY (id_utrka) REFERENCES utrka(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (id_vozac_bolid) REFERENCES vozac_bolid(id)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);



CREATE TABLE strategija (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_sudjelovanje INT NOT NULL,
    broj_ulazaka_boks INT CHECK (broj_ulazaka_boks >= 0),
    tipovi_guma VARCHAR(100),
    FOREIGN KEY (id_sudjelovanje) REFERENCES sudjelovanje(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE kazna (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_sudjelovanje INT NOT NULL,
    opis TEXT,
    tip_kazne VARCHAR(100),
    sekunde DECIMAL(4,1) CHECK (sekunde >= 0),
    FOREIGN KEY (id_sudjelovanje) REFERENCES sudjelovanje(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE poredak (
	id INT AUTO_INCREMENT PRIMARY KEY,
	id_vozac INT NOT NULL,
    id_sezona INT NOT NULL,
    id_kazna INT,
	mjesto INT NOT NULL CHECK (mjesto > 0),
    bodovi INT NOT NULL DEFAULT 0,
    pobjede INT NOT NULL DEFAULT 0,
    postolja INT DEFAULT 0,
    FOREIGN KEY (id_vozac) REFERENCES vozac(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (id_sezona) REFERENCES sezona(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (id_kazna) REFERENCES kazna(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE sponzor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(100) NOT NULL,
    drzava VARCHAR(50) NOT NULL,
    tip VARCHAR(100)
);



CREATE TABLE ugovor (
	id INT AUTO_INCREMENT PRIMARY KEY,
    id_tim INT NOT NULL,
    id_sponzor INT NOT NULL,
    godina_od YEAR,
    godina_do YEAR,
    vrijednost DECIMAL(15,2) CHECK (vrijednost >= 0),
    FOREIGN KEY (id_tim) REFERENCES tim(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_sponzor) REFERENCES sponzor(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);



CREATE TABLE osoblje (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_tim INT NOT NULL,
    ime VARCHAR(100),
    prezime VARCHAR(100),
    uloga VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_tim) REFERENCES tim(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE zaduzenje (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_osoblje INT NOT NULL,
    id_utrka INT NOT NULL,
    opis TEXT,
    FOREIGN KEY (id_osoblje) REFERENCES osoblje(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_utrka) REFERENCES utrka(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);



CREATE TABLE trosak_tima (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_tim INT NOT NULL,
    godina YEAR NOT NULL,
    kategorija VARCHAR(100),
    iznos DECIMAL(15,2) CHECK (iznos >= 0),
    FOREIGN KEY (id_tim) REFERENCES tim(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);



INSERT INTO tim ( naziv, vlasnik, baza, drzava, budzet) VALUES
( 'Red Bull Racing', 'Red Bull GmbH', 'Milton Keynes', 'UK', 145000000),
( 'Ferrari', 'Ferrari S.p.A.', 'Maranello', 'Italija', 150000000),
( 'Mercedes AMG F1', 'Mercedes-Benz', 'Brackley', 'UK', 140000000),
( 'McLaren', 'McLaren Group', 'Woking', 'UK', 135000000),
( 'Aston Martin', 'Lawrence Stroll', 'Silverstone', 'UK', 130000000);




INSERT INTO bolid ( id_tim, model, godina, motor, sasija) VALUES
( 1, 'RB20', 2024, 'Honda RBPT', 'RB20-Chassis'),
( 2, 'SF-24', 2024, 'Ferrari 066/10', 'SF24-Chassis'),
( 3, 'W15', 2024, 'Mercedes M15', 'W15-Chassis'),
( 4, 'MCL38', 2024, 'Mercedes M14', 'MCL38-Chassis'),
( 5, 'AMR24', 2024, 'Mercedes M14', 'AMR24-Chassis');


INSERT INTO vozac ( id_tim, ime, prezime, broj, nacionalnost, datum_rodjenja) VALUES
( 1, 'Max', 'Verstappen', 1, 'Nizozemska', '1997-09-30'),
( 1, 'Yuki', 'Tsunoda', 22, 'Japan', '2000-05-11'),

( 2, 'Charles', 'Leclerc', 16, 'Monako', '1997-10-16'),
( 2, 'Lewis', 'Hamilton', 44, 'Ujedinjeno Kraljevstvo', '1985-01-07'),

( 3, 'Kimi', 'Antonelli', 12, 'Italija', '2006-08-25'),
(3, 'George', 'Russell', 63, 'Ujedinjeno Kraljevstvo', '1998-02-15'),

( 4, 'Lando', 'Norris', 4, 'Ujedinjeno Kraljevstvo', '1999-11-13'),
(4, 'Oscar', 'Piastri', 81, 'Australija', '2001-04-06'),

( 5, 'Fernando', 'Alonso', 14, 'Španjolska', '1981-07-29'),
( 5, 'Lance', 'Stroll', 18, 'Kanada', '1998-10-29');


INSERT INTO sezona (id, godina, datum_pocetka, datum_zavrsetka) VALUES
(1, 2025, '2025-03-14', '2025-12-07');



INSERT INTO vozac_bolid (id_bolid, id_vozac, godina) VALUES
(1, 1,2025),(1, 2,2025),
(2, 3,2025),(2, 4,2025),
(3, 5,2025),(3, 6,2025),
(4, 7,2025),(4, 8,2025),
(5, 9,2025),(5, 10,2025);





INSERT INTO staza ( naziv, lokacija, drzava, duljina_km, broj_krugova) VALUES
('Bahrain International Circuit','Sakhir','Bahrain',5.41,57),
('Albert Park Circuit','Melbourne','Australia',5.28,58),
('Shanghai Circuit','Shanghai','China',5.45,56),
('Suzuka Circuit','Suzuka','Japan',5.81,53),
('Jeddah Corniche Circuit','Jeddah','Saudi Arabia',6.17,50),
('Miami International Autodrome','Miami','USA',5.41,57),
('Imola Circuit','Imola','Italy',4.91,63),
('Circuit de Monaco','Monte Carlo','Monaco',3.34,78),
('Circuit de Barcelona-Catalunya','Barcelona','Spain',4.66,66),
('Circuit Gilles Villeneuve','Montreal','Canada',4.36,70),
('Red Bull Ring','Spielberg','Austria',4.32,71),
('Silverstone Circuit','Silverstone','UK',5.89,52),
('Spa-Francorchamps','Spa','Belgium',7.00,44),
('Hungaroring','Budapest','Hungary',4.38,70),
('Zandvoort','Zandvoort','Netherlands',4.26,72),
('Monza','Monza','Italy',5.79,53),
('Baku City Circuit','Baku','Azerbaijan',6.00,51),
('Marina Bay','Singapore','Singapore',5.06,61),
('Circuit of the Americas','Austin','USA',5.51,56),
('Autodromo Hermanos Rodriguez','Mexico City','Mexico',4.30,71),
('Interlagos','São Paulo','Brazil',4.31,71),
('Las Vegas Strip Circuit','Las Vegas','USA',6.20,50),
('Lusail Circuit','Lusail','Qatar',5.42,57),
('Yas Marina Circuit','Abu Dhabi','UAE',5.28,58);



INSERT INTO utrka (naziv, id_staza, id_sezona) VALUES
('Bahrain GP',1,1),
('Australian GP',2,1),
('Chinese GP Sprint',3,1),
('Japanese GP',4,1),
('Saudi Arabian GP',5,1),
('Miami GP Sprint',6,1),
('Emilia Romagna GP',7,1),
('Monaco GP',8,1),
('Spanish GP',9,1),
('Canadian GP',10,1),
('Austrian GP',11,1),
('British GP',12,1),
('Belgian GP Sprint',13,1),
('Hungarian GP',14,1),
('Dutch GP',15,1),
('Italian GP',16,1),
('Azerbaijan GP',17,1),
('Singapore GP',18,1),
('United States GP',19,1),
('Mexico City GP',20,1),
('São Paulo GP',21,1),
('Las Vegas GP',22,1),
('Qatar GP Sprint',23,1),
('Abu Dhabi GP',24,1);



INSERT INTO sudjelovanje (id_utrka, id_vozac_bolid) VALUES
(1,8),
(2,7),
(3,4),
(4,1),
(5,1),
(6,5),
(7,8),
(8,7),
(9,8),
(10,6),
(11,7),
(12,1),
(13,8),
(14,3),
(15,8),
(16,1),
(17,1),
(18,NULL),
(19,1),
(20,7),
(21,7),
(22,7),
(23,8),
(24,1);


INSERT INTO rezultat (id_utrka, id_vozac_bolid, vrijeme) VALUES
(1, 8, '01:32:15'),
(2, 7, '01:28:40'),
(3, 4, '00:58:12'),
(4, 1, '01:29:55'),
(5, 1, '01:31:20'),
(6, 5, '00:56:48'),
(7, 8, '01:27:33'),
(8, 7, '01:34:10'),
(9, 8, '01:30:45'),
(10, 6, '01:26:59'),
(11, 7, '01:28:21'),
(12, 1, '01:33:02'),
(13, 8, '00:57:44'),
(14, 3, '01:29:10'),
(15, 8, '01:31:05'),
(16, 1, '01:28:58'),
(17, 1, '01:30:12'),
(19, 1, '01:27:49'),
(20, 7, '01:29:41'),
(21, 7, '01:28:33'),
(22, 7, '01:30:55'),
(23, 8, '00:59:01'),
(24, 1, '01:31:18');



INSERT INTO strategija ( id_sudjelovanje, broj_ulazaka_boks, tipovi_guma) VALUES
( 1, 2, 'Soft-Medium'),
( 2, 2, 'Soft-Medium'),
(3, 1, 'Medium-Hard'),
( 4, 2, 'Soft-Hard'),
(5, 3, 'Soft-Soft-Medium');

INSERT INTO kazna ( id_sudjelovanje, opis, tip_kazne, sekunde) VALUES
( 2, 'Prebrzo u boksu', 'Time Penalty', 5.0),
( 6, 'Izguravanje protivnika', 'Time Penalty', 10.0),
( 8, 'Nedopuštena granica staze', 'Time Penalty', 5.0),
( 9, 'Prekasno vraćanje položaja', 'Drive-through', 20.0),
(10,'Nepravilno startanje', 'Time Penalty', 5.0);



-- 1. Ubacujemo vozače s bodovima
INSERT INTO poredak (id_vozac, id_sezona, id_kazna, mjesto, bodovi, pobjede, postolja)
VALUES
(1, 1, NULL, 1, 175, 0, 0),   -- Verstappen
(7, 1, NULL,2,  175, 0, 0),   -- Norris
(8, 1, NULL, 3, 116, 0, 0),   -- Piastri
(3, 1, NULL, 4,  25, 0, 0),    -- Leclerc
(6, 1, NULL, 5,  25, 0, 0),    -- Russell
(4, 1, NULL, 6, 8, 0, 0),     -- Hamilton
(5, 1, NULL, 7, 8, 0, 0),     -- Antonelli
(2, 1, NULL,8,  0, 0, 0),     -- Tsunoda
(9, 1, NULL, 9, 0, 0, 0),     -- Alonso
(10, 1, NULL, 10, 0, 0, 0);    -- Stroll

-- 2. Ažuriramo mjesto po bodovima
SET @mjesto := 0;
UPDATE poredak
SET mjesto = (@mjesto := @mjesto + 1)
WHERE id_sezona = 1
ORDER BY bodovi DESC;

/*
DELIMITER //

CREATE PROCEDURE PopuniPoredakSezona(IN sezona_id INT)
BEGIN
    DECLARE @mjesto INT DEFAULT 0;

    -- Obriši postojeći poredak za tu sezonu
    DELETE FROM poredak WHERE id_sezona = sezona_id;

    -- Ubaci rezultate vozača sa sumom bodova, pobjeda i postolja
    INSERT INTO poredak (id_vozac, id_sezona, id_kazna, bodovi, pobjede, postolja)
    SELECT
        zb.id_vozac AS id_vozac,
        sez.id AS id_sezona,
        k.id AS id_kazna,
        COALESCE(SUM(r.bodovi),0) - COALESCE(SUM(k.sekunde),0) AS bodovi,
        COALESCE(SUM(CASE WHEN r.bodovi = 25 THEN 1 ELSE 0 END),0) AS pobjede,
        COALESCE(SUM(CASE WHEN r.bodovi >= 15 THEN 1 ELSE 0 END),0) AS postolja
    FROM vozac_bolid zb
    JOIN sezona sez ON zb.id_sezona = sez.id
    LEFT JOIN sudjelovanje s ON s.id_vozac_bolid = zb.id
    LEFT JOIN rezultat r ON r.id_sudjelovanje = s.id
    LEFT JOIN kazna k ON k.id_sudjelovanje = s.id
    WHERE sez.id = sezona_id
    GROUP BY zb.id_vozac, sez.id, k.id
    ORDER BY bodovi DESC;

    -- Ažuriraj mjesto po redoslijedu bodova
    SET @mjesto := 0;
    UPDATE poredak
    SET mjesto = (@mjesto := @mjesto + 1)
    WHERE id_sezona = sezona_id
    ORDER BY bodovi DESC;
END //
DELIMITER ;



*/

INSERT INTO sponzor (naziv, drzava, tip) VALUES
('Oracle','USA','Tehnologija'),
('Shell','UK','Gorivo'),
('Petronas','Malaysia','Gorivo'),
('Google','USA','Tehnologija'),
('Aramco','Saudi Arabia','Nafta');


INSERT INTO ugovor (id_tim, id_sponzor, godina_od, godina_do, vrijednost) VALUES
(1,1,2022,2026,150000000),
(2,2,2021,2025,120000000),
(3,3,2020,2024,140000000),
(4,4,2023,2025,80000000),
(5,5,2022,2026,90000000);


INSERT INTO osoblje (id_tim, ime, prezime, uloga) VALUES
( 1, 'Adrian', 'Newey', 'Chief Designer'),
( 2, 'Toto', 'Wolff', 'Team Principal'),
(3, 'Fred', 'Vasseur', 'Team Principal');

INSERT INTO zaduzenje ( id_osoblje, id_utrka, opis) VALUES
( 1, 1, 'Setup bolida'),
( 2, 2, 'Strategija utrke'),
( 3, 3, 'Operativno vodstvo');


INSERT INTO trosak_tima ( id_tim, godina, kategorija, iznos) VALUES
( 1, 2024, 'Razvoj bolida', 120000000),
( 2, 2024, 'Motor', 95000000),
( 3, 2024, 'Aerodinamika', 110000000),
( 4, 2024, 'Logistika', 50000000),
( 5, 2024, 'Plaće osoblja', 70000000);

-- ------------------------------------------------------------------------------------------------------------------------------------
-- na dopušta promjenu imena tijekom sezone
DELIMITER //
CREATE TRIGGER bu_naziv
	BEFORE UPDATE ON tim
	FOR EACH ROW
BEGIN

	DECLARE cur_s INT DEFAULT 0; 

	IF NEW.naziv != OLD.naziv THEN
		SELECT count(*)
			INTO cur_s
			FROM sezona
            WHERE sezona.godina = YEAR(CURDATE())
			AND MONTH(CURDATE()) BETWEEN 3 AND 12;
            
		IF cur_s > 0 THEN
			SIGNAL SQLSTATE '40000'
			SET MESSAGE_TEXT = 'Zabranjeno mjenjanje imena';
		END IF;
	END IF;
    
END// 
DELIMITER ;

-- --------------------------------------------------------------------------------------------------------------------------
-- automatski dodaje kaznu na vrijeme
DELIMITER //
CREATE TRIGGER ai_vrijeme
	AFTER INSERT ON kazna
	FOR EACH ROW
BEGIN
	DECLARE trka_id INT;
    DECLARE vozac_id INT;
    
    SELECT id_utrka, id_vozac_bolid
		INTO trka_id, vozac_id
        FROM sudjelovanje
        WHERE id = NEW.id_sudjelovanje;
    
	UPDATE rezultat 
    SET vrijeme	= addtime(vrijeme, sec_to_time(NEW.sekunde)) 
    WHERE id_utrka = trka_id AND id_vozac_bolid = vozac_id;
    
END//
DELIMITER ;

-- --------------------------------------------------------------------------------------------------------------------------
-- automatski dodaje bodove vozacima u prvih 10, pobjede i podiume
DELIMITER //
CREATE TRIGGER au_poredak
	AFTER UPDATE ON utrka
	FOR EACH ROW
    
BEGIN

	DECLARE kraj INT DEFAULT 0;
    DECLARE pozicija INT;
    DECLARE bod_add INT;
    DECLARE vozac_id INT;
    DECLARE sezona_id INT;
    DECLARE vb_id INT;
    
	DECLARE cur CURSOR FOR
		SELECT id_vozac_bolid
			FROM rezultat
			WHERE id_utrka = NEW.id
			ORDER BY vrijeme ASC, id ASC;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET kraj = 1;
	
	IF OLD.status = 'Traje' AND NEW.status = 'Zavrsena' THEN
		SELECT id_sezona 
			INTO sezona_id 
			FROM utrka 
			WHERE id = NEW.id;
            
		SET pozicija = 0;
        
        OPEN cur;
        
        read_loop: LOOP
        FETCH cur INTO vb_id;
                
		IF kraj = 1 THEN
			LEAVE read_loop;
		END IF;
        
        SET pozicija = pozicija + 1;
        
		SET bod_add = CASE pozicija
			WHEN 1 THEN 25
			WHEN 2 THEN 18
			WHEN 3 THEN 15
			WHEN 4 THEN 12
			WHEN 5 THEN 10
			WHEN 6 THEN 8
			WHEN 7 THEN 6
			WHEN 8 THEN 4
			WHEN 9 THEN 2
			WHEN 10 THEN 1
			ELSE 0
		END;
        
		IF pozicija = 1 THEN
			UPDATE poredak
				SET pobjede = pobjede + 1
				WHERE id_vozac = vozac_id
				AND id_sezona = sezona_id;
		END IF;
            
		IF pozicija <= 3 THEN
			UPDATE poredak
				SET postolja = postolja + 1
				WHERE id_vozac = vozac_id
				AND id_sezona = sezona_id;
		END IF;
        
        IF bod_add > 0 THEN
			SELECT id_vozac
				INTO vozac_id
				FROM vozac_bolid
				WHERE id = vb_id;
                
			UPDATE poredak 
				SET bodovi = bodovi + bod_add
				WHERE id_vozac = vozac_id AND id_sezona = sezona_id;
		END IF;
        END LOOP;
        CLOSE cur;
	END IF;
END//
DELIMITER ;

-- --------------------------------------------------------------------------------------------------------------------------
-- smanjuje budžet nakon troškova i sprječava prelazak tog budžeta
DELIMITER //
CREATE TRIGGER bi_trosak
	BEFORE INSERT ON trosak_tima
    FOR EACH ROW
BEGIN

	DECLARE budg DECIMAL(15,2);
    
    SELECT budzet
		INTO budg
        FROM tim
        WHERE id = NEW.id_tim;
	
	IF NEW.iznos > budg THEN
		SIGNAL SQLSTATE '40000'
		SET MESSAGE_TEXT = 'Nema dovoljno sredstava u budžetu';
	ELSE
		UPDATE tim
			SET budzet = budzet - NEW.iznos
            WHERE id = NEW.id_tim;
	END IF;
    
END //
DELIMITER ;

-- --------------------------------------------------------------------------------------------------------------------------
-- ne dopušta insert mlađir od 18
DELIMITER //
CREATE TRIGGER bi_datum_rodenja
	BEFORE INSERT ON vozac
    FOR EACH ROW
BEGIN
 
	IF NEW.datum_rodjenja > date_sub(curdate(), interval 18 year) THEN
		SIGNAL SQLSTATE '40000'
		SET MESSAGE_TEXT = 'Vozač premlad';
	END IF;
    
END//
DELIMITER ;
INSERT INTO vozac ( id_tim, ime, prezime, broj, nacionalnost, datum_rodjenja) VALUES
( 1, 'Ivan', 'ivica', 1, 'Nizozemska', '2009-09-30');

-- --------------------------------------------------------------------------------------------------------------------------
