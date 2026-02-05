-- =====================================================
-- Epic Progression System - Quest Translations
-- =====================================================
-- All translations for epic progression quests
-- Locales: deDE, esES, esMX, frFR, ruRU, zhCN, zhTW
-- =====================================================

DELETE FROM `quest_template_locale` WHERE `ID` BETWEEN 100001 AND 100014;

-- =====================================================
-- GERMAN (deDE)
-- =====================================================
INSERT INTO `quest_template_locale` (`ID`, `locale`, `Title`, `Details`, `Objectives`, `EndText`, `CompletedText`, `ObjectiveText1`, `ObjectiveText2`, `ObjectiveText3`) VALUES
(100001, 'deDE', 'Der Geschmolzene Kern', 'Champion, die Stunde deiner ersten großen Prüfung ist gekommen.\n\nDer Geschmolzene Kern brennt unter dem Schwarzfels. Ragnaros ist ausgebrochen.\n\nSteige in die vulkanischen Tiefen hinab. Stelle dich seinen Leutnants und dann Ragnaros selbst.\n\nDies ist deine Feuertaufe, Held.', 'Ragnaros, der Feuerlord, bedroht Azeroth vom Schwarzfels.', '', '', 'Ragnaros besiegt', '', ''),
(100002, 'deDE', 'Der Pechschwingenhort', 'Du hast dich gegen elementare Wut bewiesen. Nun stelle dich drakonischer Bosheit.\n\nNefarian führt das Erbe seines Vaters fort.', 'Nefarian, Sohn des Todesschwinge, plant auf dem Schwarzfels.', '', '', 'Nefarian besiegt', '', ''),
(100003, 'deDE', 'Die Trommeln von Zul''Gurub', 'Der Blutgott erhebt sich, Champion.\n\nTief in Zul''Gurub haben die Gurubashi verbotene Rituale durchgeführt.', 'Die Gurubashi-Trolle haben Hakkar den Seelenräuber erweckt.', '', '', 'Hakkar besiegt', '', ''),
(100004, 'deDE', 'Die Tore von Ahn''Qiraj', 'Das ist es, Champion. Die letzte Prüfung.\n\nHinter den Toren von Ahn''Qiraj lauern unvorstellbare Schrecken.\n\nDAS DUNKLE PORTAL RUFT DICH, CHAMPION.', 'C''Thun, ein Alter Gott, regt sich im Tempel von Ahn''Qiraj.', '', '', 'C''Thun besiegt', 'Ossirian zerstört', ''),
(100005, 'deDE', 'Die Erste Dunkelheit', '*Ein warmes Licht umhüllt deinen Geist*\n\nKind des Lichts... du bist stark geworden. Aber Dunkelheit bleibt. In Karazhan, Prinz Malchezaar. In den Bergen, Gruul. Unter dem Höllenfeuerbollwerk, Magtheridon.', 'Drei Bedrohungen lauern über der Scherbenwelt.', '', '', 'Prinz Malchezaar', 'Gruul', 'Magtheridon'),
(100006, 'deDE', 'Schlangen und Sonnenfeuer', 'Champion... zwei von Illidans ergebensten Dienern bedrohen das Gleichgewicht dieser Welt.', 'Lady Vashj und Kael''thas befehligen Illidans Streitkräfte.', '', '', 'Lady Vashj', 'Kael''thas Sonnenwanderer', ''),
(100007, 'deDE', 'Legenden Müssen Fallen', 'Die Stunde der Abrechnung naht, Champion.\n\nIn den Höhlen der Zeit hängt die Geschichte selbst in der Schwebe. Und im Schwarzen Tempel... wartet Illidan.', 'Archimonde und Illidan erwarten dein Urteil.', '', '', 'Archimonde', 'Illidan der Verräter', ''),
(100008, 'deDE', 'Der Zorn von Zul''Aman', 'Kind des Lichts... die Waldtrolle regen sich wieder.\n\nZul''jin - eine von Rache verzehrte Seele - versammelt sein Volk zum Krieg.', 'Zul''jin versammelt die Amani zum Krieg.', '', '', 'Zul''jin', '', ''),
(100009, 'deDE', 'Der Sonnenbrunnen Wiederhergestellt', 'CHAMPION! Der Betrüger kommt!\n\nKil''jaeden erhebt sich durch den Sonnenbrunnen.\n\nWENN DU SIEGREICH ZURÜCKKEHRST, RUFT EIN GEFRORENES LAND. NORDEND ERWARTET DICH.', 'Kil''jaeden versucht, Azeroth zu betreten.', '', '', 'Kil''jaeden verbannt', '', ''),
(100010, 'deDE', 'Die Ersten Prüfungen des Nordens', 'Champion, die Kirin Tor brauchen wieder deine Stärke.\n\nNAXXRAMAS - Kel''Thuzads Zitadelle schwebt über der Drachenöde.\nDAS AUGE DER EWIGKEIT - Malygos hat allen sterblichen Magiern den Krieg erklärt.\nDAS OBSIDIANSANKTUM - Sartharion bewacht Schattendracheneier.', 'Drei Bedrohungen erfordern die Aufmerksamkeit der Kirin Tor.', '', '', 'Kel''Thuzad', 'Malygos', 'Sartharion'),
(100011, 'deDE', 'Das Gefängnis von Yogg-Saron', 'Bei Antonidas'' Bart... die Situation in Ulduar ist schlimmer als befürchtet.\n\nYogg-Saron - der Gott des Todes - regt sich in seinem Gefängnis.', 'Ein Alter Gott flüstert aus Ulduar.', '', '', 'Yogg-Saron besiegt', '', ''),
(100012, 'deDE', 'Die Letzte Prüfung des Kreuzzugs', 'Tirion Fordring sendet Nachricht vom Argentumturnier. Arthas hat Anub''arak unter dem Kolosseum platziert.\n\nDer Schattenhammer hat Onyxia wiederbelebt.', 'Das Argentumturnier und Onyxias Rückkehr.', '', '', 'Anub''arak', 'Onyxia', ''),
(100013, 'deDE', 'Der Fall des Lichkönigs', 'Der Tag ist gekommen, Champion.\n\nDie Eiskronenzitadelle ist offen. Tirion Fordring führt den Angriff. Und auf dem Frostthron... wartet Arthas.\n\nBeende Arthas Menethil. Beende die Geißel. Rette unsere Welt.', 'Arthas wartet auf dem Frostthron.', '', '', 'Der Lichkönig', '', ''),
(100014, 'deDE', 'Der Zwielichtzerstörer', 'Champion - ich hoffte, nach dem Fall des Lichkönigs hätten wir Frieden. Ich lag falsch.\n\nHalion führt eine Armee gegen den roten Drachenschwarm.\n\nDEINE LEGENDE IST VOLLSTÄNDIG.', 'Halion greift das Rubinsanktum an.', '', '', 'Halion besiegt', '', '');

-- =====================================================
-- SPANISH (esES)
-- =====================================================
INSERT INTO `quest_template_locale` (`ID`, `locale`, `Title`, `Details`, `Objectives`, `EndText`, `CompletedText`, `ObjectiveText1`, `ObjectiveText2`, `ObjectiveText3`) VALUES
(100001, 'esES', 'El Núcleo de Magma', 'Campeón, la hora de tu primera gran prueba ha llegado.\n\nEl Núcleo de Magma arde bajo Montaña Roca Negra. Ragnaros se ha liberado.\n\nDesciende a las profundidades volcánicas. Enfrenta a sus lugartenientes y luego a Ragnaros.\n\nEste es tu bautismo de fuego, héroe.', 'Ragnaros, el Señor del Fuego, amenaza Azeroth desde Montaña Roca Negra.', '', '', 'Ragnaros derrotado', '', ''),
(100002, 'esES', 'La Guarida de Alanegra', 'Has demostrado tu valor contra la furia elemental. Ahora enfrenta la malicia dracónica.\n\nNefarian continúa el legado de destrucción de su padre.', 'Nefarian, hijo de Alamuerte, conspira en la cima de Montaña Roca Negra.', '', '', 'Nefarian derrotado', '', ''),
(100003, 'esES', 'Los Tambores de Zul''Gurub', 'El Dios de la Sangre se levanta, campeón.\n\nEn lo profundo de Zul''Gurub, los Gurubashi han realizado rituales prohibidos.', 'Los trolls Gurubashi han despertado a Hakkar el Desollador de Almas.', '', '', 'Hakkar derrotado', '', ''),
(100004, 'esES', 'Las Puertas de Ahn''Qiraj', 'Es la hora, campeón. La prueba final de tu valor.\n\nDetrás de las Puertas de Ahn''Qiraj yacen horrores más allá de la comprensión.\n\nEL PORTAL OSCURO TE LLAMA, CAMPEÓN.', 'C''Thun, un Dios Antiguo, se agita en el Templo de Ahn''Qiraj.', '', '', 'C''Thun vencido', 'Ossirian destruido', ''),
(100005, 'esES', 'La Primera Oscuridad', '*Una luz cálida envuelve tu mente*\n\nHijo de la Luz... te has fortalecido. Pero la oscuridad persiste. En Karazhan, el Príncipe Malchezaar. En las montañas, Gruul. Bajo Ciudadela del Fuego Infernal, Magtheridon.', 'Tres amenazas se ciernen sobre Terrallende.', '', '', 'Príncipe Malchezaar', 'Gruul', 'Magtheridon'),
(100006, 'esES', 'Serpientes y Fuego Solar', 'Campeón... dos de los siervos más devotos de Illidan amenazan el equilibrio de este mundo.', 'Lady Vashj y Kael''thas comandan las fuerzas de Illidan.', '', '', 'Lady Vashj', 'Kael''thas Caminante del Sol', ''),
(100007, 'esES', 'Las Leyendas Deben Caer', 'La hora del ajuste de cuentas se acerca, campeón.\n\nEn las Cavernas del Tiempo, la historia misma pende de un hilo. Y en el Templo Oscuro... Illidan espera. El Traidor.', 'Archimonde e Illidan esperan tu juicio.', '', '', 'Archimonde', 'Illidan el Traidor', ''),
(100008, 'esES', 'La Furia de Zul''Aman', 'Hijo de la Luz... los trolls del bosque se agitan de nuevo.\n\nZul''jin - un alma consumida por la venganza - reúne a su pueblo para la guerra.', 'Zul''jin reúne a los Amani para la guerra.', '', '', 'Zul''jin', '', ''),
(100009, 'esES', 'La Fuente del Sol Restaurada', '¡CAMPEÓN! ¡El Engañador viene!\n\nKil''jaeden se eleva a través de la Fuente del Sol.\n\nCUANDO REGRESES VICTORIOSO, UNA TIERRA HELADA TE LLAMA. RASGANORTE TE ESPERA.', 'Kil''jaeden intenta entrar en Azeroth.', '', '', 'Kil''jaeden desterrado', '', ''),
(100010, 'esES', 'Las Primeras Pruebas del Norte', 'Campeón, el Kirin Tor necesita tu fuerza una vez más.\n\nNAXXRAMAS - La ciudadela de Kel''Thuzad flota sobre la Agonía de Dragones.\nEL OJO DE LA ETERNIDAD - Malygos ha declarado la guerra a toda la magia mortal.\nEL SAGRARIO OBSIDIANA - Sartharion custodia huevos de dragón crepuscular.', 'Tres amenazas demandan la atención del Kirin Tor.', '', '', 'Kel''Thuzad', 'Malygos', 'Sartharion'),
(100011, 'esES', 'La Prisión de Yogg-Saron', '¡Por la barba de Antonidas! La situación en Ulduar es peor de lo que temíamos.\n\nYogg-Saron - el Dios de la Muerte - se agita en su prisión.', 'Un Dios Antiguo susurra desde Ulduar.', '', '', 'Yogg-Saron vencido', '', ''),
(100012, 'esES', 'La Prueba Final de la Cruzada', 'Tirion Vadín envía noticias desde el Torneo Argenta. Arthas ha colocado a Anub''arak bajo el coliseo.\n\nEl Martillo Crepuscular ha resucitado a Onyxia.', 'El Torneo Argenta y el regreso de Onyxia.', '', '', 'Anub''arak', 'Onyxia', ''),
(100013, 'esES', 'La Caída del Rey Exánime', 'El día ha llegado, campeón.\n\nLa Ciudadela de la Corona de Hielo está abierta. Tirion Vadín lidera el asalto. Y en la cima del Trono Helado... Arthas espera.\n\nAcaba con Arthas Menethil. Acaba con la Plaga. Salva nuestro mundo.', 'Arthas espera en el Trono Helado.', '', '', 'El Rey Exánime', '', ''),
(100014, 'esES', 'El Destructor Crepuscular', 'Campeón - esperaba que tras la caída del Rey Exánime tendríamos paz. Me equivoqué.\n\nHalion lidera un ejército contra el vuelo de dragones rojos.\n\nTU LEYENDA ESTÁ COMPLETA.', 'Halion ataca el Sagrario Rubí.', '', '', 'Halion derrotado', '', '');

-- =====================================================
-- SPANISH MEXICO (esMX) - Same as esES
-- =====================================================
INSERT INTO `quest_template_locale` (`ID`, `locale`, `Title`, `Details`, `Objectives`, `EndText`, `CompletedText`, `ObjectiveText1`, `ObjectiveText2`, `ObjectiveText3`)
SELECT `ID`, 'esMX', `Title`, `Details`, `Objectives`, `EndText`, `CompletedText`, `ObjectiveText1`, `ObjectiveText2`, `ObjectiveText3`
FROM `quest_template_locale` WHERE `locale` = 'esES' AND `ID` BETWEEN 100001 AND 100014;

-- =====================================================
-- FRENCH (frFR)
-- =====================================================
INSERT INTO `quest_template_locale` (`ID`, `locale`, `Title`, `Details`, `Objectives`, `EndText`, `CompletedText`, `ObjectiveText1`, `ObjectiveText2`, `ObjectiveText3`) VALUES
(100001, 'frFR', 'Le Cœur du Magma', 'Champion, l''heure de ta première grande épreuve est venue.\n\nLe Cœur du Magma brûle sous la Montagne Rochenoire. Ragnaros s''est libéré.\n\nDescends dans les profondeurs volcaniques. Affronte ses lieutenants puis Ragnaros lui-même.\n\nC''est ton baptême du feu, héros.', 'Ragnaros, le Seigneur du Feu, menace Azeroth depuis la Montagne Rochenoire.', '', '', 'Ragnaros terrassé', '', ''),
(100002, 'frFR', 'Le Repaire de l''Aile Noire', 'Tu as fait tes preuves contre la fureur élémentaire. Maintenant, affronte la malveillance draconique.\n\nNefarian poursuit l''héritage de destruction de son père.', 'Nefarian, fils d''Aile de mort, complote au sommet de la Montagne Rochenoire.', '', '', 'Nefarian terrassé', '', ''),
(100003, 'frFR', 'Les Tambours de Zul''Gurub', 'Le Dieu du Sang se lève, champion.\n\nAu plus profond de Zul''Gurub, les Gurubashi ont accompli des rituels interdits.', 'Les trolls Gurubashi ont éveillé Hakkar l''Écorcheur d''âmes.', '', '', 'Hakkar terrassé', '', ''),
(100004, 'frFR', 'Les Portes d''Ahn''Qiraj', 'Ça y est, champion. L''épreuve finale de ta valeur.\n\nDerrière les Portes d''Ahn''Qiraj se cachent des horreurs au-delà de toute compréhension.\n\nLA PORTE DES TÉNÈBRES T''APPELLE, CHAMPION.', 'C''Thun, un Dieu Très Ancien, s''agite dans le Temple d''Ahn''Qiraj.', '', '', 'C''Thun vaincu', 'Ossirian détruit', ''),
(100005, 'frFR', 'Les Premières Ténèbres', '*Une lumière chaleureuse enveloppe ton esprit*\n\nEnfant de la Lumière... tu es devenu fort. Mais les ténèbres persistent. À Karazhan, le Prince Malchezaar. Dans les montagnes, Gruul. Sous la Citadelle des Flammes infernales, Magtheridon.', 'Trois menaces planent sur l''Outreterre.', '', '', 'Prince Malchezaar', 'Gruul', 'Magtheridon'),
(100006, 'frFR', 'Serpents et Feu Solaire', 'Champion... deux des serviteurs les plus dévoués d''Illidan menacent l''équilibre de ce monde.', 'Dame Vashj et Kael''thas commandent les forces d''Illidan.', '', '', 'Dame Vashj', 'Kael''thas Haut-Soleil', ''),
(100007, 'frFR', 'Les Légendes Doivent Tomber', 'L''heure du jugement approche, champion.\n\nDans les Grottes du Temps, l''histoire elle-même est en jeu. Et dans le Temple Noir... Illidan attend. Le Traître.', 'Archimonde et Illidan attendent ton jugement.', '', '', 'Archimonde', 'Illidan le Traître', ''),
(100008, 'frFR', 'La Fureur de Zul''Aman', 'Enfant de la Lumière... les trolls des forêts s''agitent à nouveau.\n\nZul''jin - une âme consumée par la vengeance - rassemble son peuple pour la guerre.', 'Zul''jin rassemble les Amani pour la guerre.', '', '', 'Zul''jin', '', ''),
(100009, 'frFR', 'Le Puits de Soleil Restauré', 'CHAMPION ! Le Trompeur arrive !\n\nKil''jaeden s''élève à travers le Puits de Soleil.\n\nQUAND TU REVIENDRAS VICTORIEUX, UNE TERRE GELÉE T''APPELLE. LE NORFENDRE T''ATTEND.', 'Kil''jaeden tente d''entrer dans Azeroth.', '', '', 'Kil''jaeden banni', '', ''),
(100010, 'frFR', 'Les Premières Épreuves du Nord', 'Champion, le Kirin Tor a besoin de ta force une fois de plus.\n\nNAXXRAMAS - La citadelle de Kel''Thuzad flotte au-dessus de la Désolation des dragons.\nL''ŒIL DE L''ÉTERNITÉ - Malygos a déclaré la guerre à toute la magie mortelle.\nLE SANCTUM OBSIDIEN - Sartharion garde les œufs de dragons du crépuscule.', 'Trois menaces réclament l''attention du Kirin Tor.', '', '', 'Kel''Thuzad', 'Malygos', 'Sartharion'),
(100011, 'frFR', 'La Prison de Yogg-Saron', 'Par la barbe d''Antonidas... la situation à Ulduar est pire que nous le craignions.\n\nYogg-Saron - le Dieu de la Mort - s''agite dans sa prison.', 'Un Dieu Très Ancien murmure depuis Ulduar.', '', '', 'Yogg-Saron vaincu', '', ''),
(100012, 'frFR', 'L''Épreuve Finale de la Croisade', 'Tirion Fordring envoie des nouvelles du Tournoi d''Argent. Arthas a placé Anub''arak sous le Colisée.\n\nLe Marteau du Crépuscule a ressuscité Onyxia.', 'Le Tournoi d''Argent et le retour d''Onyxia.', '', '', 'Anub''arak', 'Onyxia', ''),
(100013, 'frFR', 'La Chute du Roi-liche', 'Le jour est venu, champion.\n\nLa Citadelle de la Couronne de glace est ouverte. Tirion Fordring mène l''assaut. Et au sommet du Trône de Glace... Arthas attend.\n\nMets fin à Arthas Menethil. Mets fin au Fléau. Sauve notre monde.', 'Arthas attend au Trône de Glace.', '', '', 'Le Roi-liche', '', ''),
(100014, 'frFR', 'Le Destructeur du Crépuscule', 'Champion - j''espérais qu''après la chute du Roi-liche, nous aurions la paix. J''avais tort.\n\nHalion mène une armée contre le vol draconique rouge.\n\nTA LÉGENDE EST COMPLÈTE.', 'Halion attaque le Sanctum Rubis.', '', '', 'Halion terrassé', '', '');

-- =====================================================
-- RUSSIAN (ruRU)
-- =====================================================
INSERT INTO `quest_template_locale` (`ID`, `locale`, `Title`, `Details`, `Objectives`, `EndText`, `CompletedText`, `ObjectiveText1`, `ObjectiveText2`, `ObjectiveText3`) VALUES
(100001, 'ruRU', 'Огненные Недра', 'Чемпион, час твоего первого великого испытания настал.\n\nОгненные Недра горят под Черной горой. Рагнарос вырвался на свободу.\n\nСпустись в вулканические глубины. Сразись с его лейтенантами, а затем с самим Рагнаросом.\n\nЭто твое боевое крещение, герой.', 'Рагнарос, Повелитель Огня, угрожает Азероту из Черной горы.', '', '', 'Рагнарос повержен', '', ''),
(100002, 'ruRU', 'Логово Крыла Тьмы', 'Ты доказал свою доблесть против стихийной ярости. Теперь встреться с драконьим злом.\n\nНефариан продолжает наследие разрушения своего отца.', 'Нефариан, сын Смертокрыла, плетет интриги на вершине Черной горы.', '', '', 'Нефариан повержен', '', ''),
(100003, 'ruRU', 'Барабаны Зул''Гуруба', 'Бог Крови восстает, чемпион.\n\nВ глубинах Зул''Гуруба Гурубаши провели запретные ритуалы.', 'Тролли Гурубаши пробудили Хаккара Свежевателя Душ.', '', '', 'Хаккар повержен', '', ''),
(100004, 'ruRU', 'Врата Ан''Киража', 'Вот и все, чемпион. Последнее испытание твоей доблести.\n\nЗа Вратами Ан''Киража скрываются ужасы за гранью понимания.\n\nТЕМНЫЙ ПОРТАЛ ЗОВЕТ ТЕБЯ, ЧЕМПИОН.', 'К''Тун, Древний Бог, шевелится в Храме Ан''Киража.', '', '', 'К''Тун побежден', 'Оссириан уничтожен', ''),
(100005, 'ruRU', 'Первая Тьма', '*Теплый свет окутывает твой разум*\n\nДитя Света... ты стал сильным. Но тьма не отступает. В Каражане - принц Малчезаар. В горах - Груул. Под Цитаделью Адского Пламени - Магтеридон.', 'Три угрозы нависли над Запредельем.', '', '', 'Принц Малчезаар', 'Груул', 'Магтеридон'),
(100006, 'ruRU', 'Змеи и Солнечный Огонь', 'Чемпион... двое самых преданных слуг Иллидана угрожают равновесию этого мира.', 'Леди Вайш и Кель''тас командуют силами Иллидана.', '', '', 'Леди Вайш', 'Кель''тас Солнечный Скиталец', ''),
(100007, 'ruRU', 'Легенды Должны Пасть', 'Час расплаты близок, чемпион.\n\nВ Пещерах Времени сама история висит на волоске. А в Черном Храме... ждет Иллидан. Предатель.', 'Архимонд и Иллидан ждут твоего суда.', '', '', 'Архимонд', 'Иллидан Предатель', ''),
(100008, 'ruRU', 'Ярость Зул''Амана', 'Дитя Света... лесные тролли снова волнуются.\n\nЗул''джин - душа, поглощенная местью - собирает свой народ на войну.', 'Зул''джин собирает Амани на войну.', '', '', 'Зул''джин', '', ''),
(100009, 'ruRU', 'Солнечный Колодец Восстановлен', 'ЧЕМПИОН! Обманщик идет!\n\nКил''джеден поднимается через Солнечный Колодец.\n\nКОГДА ТЫ ВЕРНЕШЬСЯ С ПОБЕДОЙ, ЗАМЕРЗШАЯ ЗЕМЛЯ ЗОВЕТ. НОРДСКОЛ ЖДЕТ ТЕБЯ.', 'Кил''джеден пытается войти в Азерот.', '', '', 'Кил''джеден изгнан', '', ''),
(100010, 'ruRU', 'Первые Испытания Севера', 'Чемпион, Кирин-Тору снова нужна твоя сила.\n\nНАКСРАМАС - Цитадель Кел''Тузада парит над Драконьим Погостом.\nОКО ВЕЧНОСТИ - Малигос объявил войну всей смертной магии.\nОБСИДИАНОВОЕ СВЯТИЛИЩЕ - Сартарион охраняет яйца сумеречных драконов.', 'Три угрозы требуют внимания Кирин-Тора.', '', '', 'Кел''Тузад', 'Малигос', 'Сартарион'),
(100011, 'ruRU', 'Темница Йогг-Сарона', 'Клянусь бородой Антонидаса... ситуация в Ульдуаре хуже, чем мы опасались.\n\nЙогг-Сарон - Бог Смерти - шевелится в своей темнице.', 'Древний Бог шепчет из Ульдуара.', '', '', 'Йогг-Сарон побежден', '', ''),
(100012, 'ruRU', 'Последнее Испытание Крестового Похода', 'Тирион Фордринг шлет вести с Серебряного турнира. Артас поместил Ануб''арака под Колизеем.\n\nСумеречный Молот воскресил Ониксию.', 'Серебряный турнир и возвращение Ониксии.', '', '', 'Ануб''арак', 'Ониксия', ''),
(100013, 'ruRU', 'Падение Короля-лича', 'День настал, чемпион.\n\nЦитадель Ледяной Короны открыта. Тирион Фордринг ведет штурм. И на вершине Ледяного Трона... ждет Артас.\n\nПокончи с Артасом Менетилом. Покончи с Плетью. Спаси наш мир.', 'Артас ждет на Ледяном Троне.', '', '', 'Король-лич', '', ''),
(100014, 'ruRU', 'Сумеречный Разрушитель', 'Чемпион - я надеялся, что после падения Короля-лича наступит мир. Я ошибался.\n\nХалион ведет армию против красного драконьего роя.\n\nТВОЯ ЛЕГЕНДА ЗАВЕРШЕНА.', 'Халион атакует Рубиновое Святилище.', '', '', 'Халион повержен', '', '');

-- =====================================================
-- CHINESE SIMPLIFIED (zhCN)
-- =====================================================
INSERT INTO `quest_template_locale` (`ID`, `locale`, `Title`, `Details`, `Objectives`, `EndText`, `CompletedText`, `ObjectiveText1`, `ObjectiveText2`, `ObjectiveText3`) VALUES
(100001, 'zhCN', '熔火之心', '勇士，你的第一次伟大考验时刻已经到来。\n\n熔火之心在黑石山下燃烧。拉格纳罗斯已经挣脱束缚。\n\n深入火山深处。击败他的手下，然后挑战拉格纳罗斯本人。\n\n这是你的战火洗礼，英雄。', '炎魔拉格纳罗斯从黑石山威胁着艾泽拉斯。', '', '', '击败拉格纳罗斯', '', ''),
(100002, 'zhCN', '黑翼之巢', '你已证明了自己对抗元素之怒的能力。现在面对龙族的恶意。\n\n奈法利安延续着他父亲的毁灭遗产。', '死亡之翼之子奈法利安在黑石山顶密谋。', '', '', '击败奈法利安', '', ''),
(100003, 'zhCN', '祖尔格拉布的战鼓', '血神升起了，勇士。\n\n在祖尔格拉布深处，古拉巴什进行了禁忌的仪式。', '古拉巴什巨魔唤醒了夺灵者哈卡。', '', '', '击败哈卡', '', ''),
(100004, 'zhCN', '安其拉之门', '就是现在，勇士。你价值的最终考验。\n\n安其拉之门后隐藏着超乎理解的恐怖。\n\n黑暗之门在呼唤你，勇士。', '古神克苏恩在安其拉神殿中蠢蠢欲动。', '', '', '击败克苏恩', '消灭奥斯里安', ''),
(100005, 'zhCN', '第一道黑暗', '*温暖的光芒包围着你的心灵*\n\n光明之子...你已经变强了。但黑暗依然存在。在卡拉赞，玛克扎尔王子。在山中，格鲁尔。在地狱火堡垒下，玛瑟里顿。', '三个威胁笼罩着外域。', '', '', '玛克扎尔王子', '格鲁尔', '玛瑟里顿'),
(100006, 'zhCN', '蛇与太阳之火', '勇士...伊利丹最忠诚的两个仆从威胁着这个世界的平衡。', '瓦丝琪女士和凯尔萨斯指挥着伊利丹的军队。', '', '', '瓦丝琪女士', '凯尔萨斯·逐日者', ''),
(100007, 'zhCN', '传说必须陨落', '清算的时刻临近了，勇士。\n\n在时光之穴，历史本身岌岌可危。在黑暗神殿...伊利丹在等待。背叛者。', '阿克蒙德和伊利丹等待你的审判。', '', '', '阿克蒙德', '背叛者伊利丹', ''),
(100008, 'zhCN', '祖阿曼的愤怒', '光明之子...森林巨魔再次躁动。\n\n祖尔金——一个被复仇吞噬的灵魂——召集他的人民准备战争。', '祖尔金召集阿曼尼准备战争。', '', '', '祖尔金', '', ''),
(100009, 'zhCN', '太阳之井的复兴', '勇士！欺诈者来了！\n\n基尔加丹正穿过太阳之井升起。\n\n当你凯旋归来，一片冰冻之地在召唤。诺森德在等待你。', '基尔加丹试图进入艾泽拉斯。', '', '', '驱逐基尔加丹', '', ''),
(100010, 'zhCN', '北方的第一次考验', '勇士，肯瑞托再次需要你的力量。\n\n纳克萨玛斯 - 克尔苏加德的堡垒漂浮在龙骨荒野上空。\n永恒之眼 - 玛里苟斯向所有凡人法术宣战。\n黑曜圣殿 - 萨塔里奥守卫着暮光龙蛋。', '三个威胁需要肯瑞托的关注。', '', '', '克尔苏加德', '玛里苟斯', '萨塔里奥'),
(100011, 'zhCN', '尤格-萨隆的牢笼', '安东尼达斯在上...奥杜尔的情况比我们担心的更糟。\n\n尤格-萨隆——死亡之神——在他的牢笼中蠢蠢欲动。', '一个古神从奥杜尔低语。', '', '', '击败尤格-萨隆', '', ''),
(100012, 'zhCN', '十字军的最终考验', '提里奥·弗丁从银色锦标赛传来消息。阿尔萨斯在竞技场下放置了阿努巴拉克。\n\n暮光之锤复活了奥妮克希亚。', '银色锦标赛和奥妮克希亚的回归。', '', '', '阿努巴拉克', '奥妮克希亚', ''),
(100013, 'zhCN', '巫妖王的陨落', '这一天到来了，勇士。\n\n冰冠堡垒敞开了大门。提里奥·弗丁领导着进攻。在冰封王座之巅...阿尔萨斯在等待。\n\n终结阿尔萨斯·米奈希尔。终结天灾。拯救我们的世界。', '阿尔萨斯在冰封王座等待。', '', '', '巫妖王', '', ''),
(100014, 'zhCN', '暮光毁灭者', '勇士——我曾希望巫妖王陨落后我们能迎来和平。我错了。\n\n海里昂率领军队对抗红龙军团。\n\n你的传奇已经完成。', '海里昂袭击红玉圣殿。', '', '', '击败海里昂', '', '');

-- =====================================================
-- CHINESE TRADITIONAL (zhTW)
-- =====================================================
INSERT INTO `quest_template_locale` (`ID`, `locale`, `Title`, `Details`, `Objectives`, `EndText`, `CompletedText`, `ObjectiveText1`, `ObjectiveText2`, `ObjectiveText3`) VALUES
(100001, 'zhTW', '乘火之心', '勇士，你的第一次偉大考驗時刻已經到來。\n\n熔火之心在黑石山下燃燒。拉格納羅斯已經掙脫束縛。\n\n深入火山深處。擊敗他的手下，然後挑戰拉格納羅斯本人。\n\n這是你的戰火洗禮，英雄。', '炎魔拉格納羅斯從黑石山威脅著艾澤拉斯。', '', '', '擊敗拉格納羅斯', '', ''),
(100002, 'zhTW', '黑翼之巢', '你已證明了自己對抗元素之怒的能力。現在面對龍族的惡意。\n\n奈法利安延續著他父親的毀滅遺產。', '死亡之翼之子奈法利安在黑石山頂密謀。', '', '', '擊敗奈法利安', '', ''),
(100003, 'zhTW', '祖爾格拉布的戰鼓', '血神升起了，勇士。\n\n在祖爾格拉布深處，古拉巴什進行了禁忌的儀式。', '古拉巴什巨魔喚醒了奪靈者哈卡。', '', '', '擊敗哈卡', '', ''),
(100004, 'zhTW', '乘其拉之門', '就是現在，勇士。你價值的最終考驗。\n\n安其拉之門後隱藏著超乎理解的恐怖。\n\n黑暗之門在呼喚你，勇士。', '古神克蘇恩在乘其拉神殿中蠢蠢欲動。', '', '', '擊敗克蘇恩', '消滅奧斯里安', ''),
(100005, 'zhTW', '第一道黑暗', '*溫暖的光芒包圍著你的心靈*\n\n光明之子...你已經變強了。但黑暗依然存在。在卡拉贊，瑪克扎爾王子。在山中，乘魯爾。在地獄火堡壘下，瑪瑟里頓。', '三個威脅籠罩著外域。', '', '', '瑪克扎爾王子', '格魯爾', '瑪瑟里頓'),
(100006, 'zhTW', '蛇與太陽之火', '勇士...伊利丹最忠誠的兩個僕從威脅著這個世界的平衡。', '瓦斯琪女士和凱爾薩斯指揮著伊利丹的軍隊。', '', '', '瓦斯琪女士', '凱爾薩斯·逐日者', ''),
(100007, 'zhTW', '傳說必須隕落', '清算的時刻臨近了，勇士。\n\n在時光之穴，歷史本身岌岌可危。在黑暗神殿...伊利丹在等待。背叛者。', '阿克蒙德和伊利丹等待你的審判。', '', '', '阿克蒙德', '背叛者伊利丹', ''),
(100008, 'zhTW', '祖阿曼的憤怒', '光明之子...森林巨魔再次躁動。\n\n祖爾金——一個被復仇吞噬的靈魂——召集他的人民準備戰爭。', '祖爾金召集阿曼尼準備戰爭。', '', '', '祖爾金', '', ''),
(100009, 'zhTW', '太陽之井的復興', '勇士！欺詐者來了！\n\n基爾加丹正穿過太陽之井升起。\n\n當你凱旋歸來，一片冰凍之地在召喚。諾乘德在等待你。', '基爾加丹試圖進入艾澤拉斯。', '', '', '驅逐基爾加丹', '', ''),
(100010, 'zhTW', '北方的第一次考驗', '勇士，肯瑞托再次需要你的力量。\n\n納克薩瑪斯 - 克爾蘇乘德的堡壘漂浮在龍骨荒野上空。\n永恆之眼 - 瑪里苟斯向所有凡人法術宣戰。\n黑曜聖殿 - 薩塔里奧守衛著暮光龍蛋。', '三個威脅需要肯瑞托的關注。', '', '', '克爾蘇乘德', '瑪里苟斯', '薩塔里奧'),
(100011, 'zhTW', '尤乘-薩隆的牢籠', '乘東尼達斯在上...奧杜爾的情況比我們擔心的更糟。\n\n尤格-薩隆——死亡之神——在他的牢籠中蠢蠢欲動。', '一個古神從奧杜爾低語。', '', '', '擊敗尤乘-薩隆', '', ''),
(100012, 'zhTW', '十字軍的最終考驗', '提里奧·弗丁從銀色錦標賽傳來消息。阿爾薩斯在競技場下放置了阿努巴拉克。\n\n暮光之錘復活了奧妮克希亞。', '銀色錦標賽和奧妮克希亞的回歸。', '', '', '阿努巴拉克', '奧妮克希亞', ''),
(100013, 'zhTW', '巫妖王的隕落', '這一天到來了，勇士。\n\n冰冠堡壘敞開了大門。提里奧·弗丁領導著進攻。在冰封王座之巔...阿爾薩斯在等待。\n\n終結阿爾薩斯·米乘希爾。終結天災。拯救我們的世界。', '阿爾薩斯在冰封王座等待。', '', '', '巫妖王', '', ''),
(100014, 'zhTW', '暮光毀滅者', '勇士——我曾希望巫妖王隕落後我們能迎來和平。我錯了。\n\n海里昂率領軍隊對抗紅龍軍團。\n\n你的傳奇已經完成。', '海里昂襲擊紅玉聖殿。', '', '', '擊敗海里昂', '', '');
