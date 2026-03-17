# RCPlane - fixed-wing dron - zadávací dokumentace

Tento repozitář má obsahovat veškerou dokumentaci k dronu s konstrukcí fixed-wing.

* Dron má být dálkově ovládaný (přes Bluetooth a na delší vzdálenost přes 4G/LTE modul - v cloudu bude hostovaná aplikace s API, na které se bude dron připojovat).
* Napájení má být Li-ion bateriemi.
* Cílový dolet má být v rozsahu 70-150km - primární je doletová vzdálenost, ale manévrovatelnost je také podstatná.
* Dosažitelná letová rychlost má být minimálně 60km/h.
* Dron má být schopen nést náklad cca 2kg (nad rámec své letové hmotnosti).
* Výroba primárně 3D tiskem (zřejmě PET-G, příp. PLA-LW) s použitím karbonových tyčí.
* Náklad se má vkládat do trupu shora - dvířka na pant, zajištěný mechanismem na cvaknutí.
* Dron má být schopen autonomně vzletět ze země z rovného povrchu (např. silnice) i přistát - potřebuje tedy zřejmě kolečka.
* Dron by měl být schopen letět za deště.

Je potřeba vypracovat veškerou dokumentaci, nejen to, co je uvedeno v tomto souboru:
* mechanika
* aerodynamika, výpočty
* 3D model konstrukce vč. jednotlivých dílů, instrukce pro konstrukci
* elektronika - použité komponenty, zapojení

Dokumentace má být strukturovaně provedena v Markdown souborech.
Zároveň je vyžadován i HTML 3D prohlížeč existujících modelů dynamicky načítaných z patřičné složky.
