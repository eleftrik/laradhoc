Laradhoc
===

![Laradhoc](media/images/laradhoc.png)

![GitHub stars](https://img.shields.io/github/stars/eleftrik/laradhoc?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/eleftrik/laradhoc?style=social)
![GitHub issues](https://img.shields.io/github/issues/eleftrik/laradhoc)
![GitHub](https://img.shields.io/github/license/eleftrik/laradhoc)
![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/eleftrik/laradhoc?label=version)

🆕 ✅ *Rilasciata la versione **2.3.0** - supporto per PHP 8.1*

**Laradhoc** è un semplice ambiente di sviluppo LEMP basato su Docker per applicazioni [Laravel](https://laravel.com/).

Cerchi qualcosa di simile per [WordPress](https://wordpress.org/)? Dai un'occhiata a
[Dockpress](https://github.com/eleftrik/dockpress)!

## Caratteristiche

* Nginx
* PHP (7.2 / 7.3 / 7.4 / 8.0 / 8.1) con OPCache
* Composer 2.0
* MySQL / MariaDB
* MongoDB
* phpMyAdmin
* Mailhog
* Redis
* Nome di dominio personalizzato (es. `http://laradhoc.test` o `https://laradhoc.test`)
* HTTP or HTTPS (tramite certificato SSL autogenerato)
* npm
* gulp (per progetti più vecchi)

Puoi scegliere quale versione di PHP utilizzare (per esempio, `7.4`) impostando la variabile `${PHP_VERSION}`
nel tuo file `.env` (vedi `.env.example` per maggiori dettagli).

In maniera simile, puoi scegliere quale database usare (per esempio, `MariaDB 10.2`) impostando la
variabile `${DATABASE_IMAGE}` nel tuo file `.env` (vedi `.env.example` per maggiori dettagli).

Nel caso in cui tu voglia personalizzare la configurazione Docker (es. aggiungendo un mount),
esegui `cp docker-compose.yml docker-compose.override.yml` quindi modifica il file
`docker-compose.override.yml`. Quest'ultimo verrà utilizzato da Docker.

## Requisiti

* MacOS, Linux o Windows con WSL
* Docker
* `openssl` (quando si usa HTTPS)

## Installazione

Clona questo repository.

Supponiamo che la tua applicazione Laravel debba essere accessibile all'indirizzo `laradhoc.test`:

```bash
git clone git@github.com:eleftrik/laradhoc.git laradhoc.test
cd laradhoc.test
```

## Comando `laradhoc`

Prima della versione `2.1.0`, dovevi

- spostarti (`cd`) nella cartella di Laradhoc
- eseguire `./bin/laradhoc`

A partire dalla versione `2.1.0`, puoi invocare `laradhoc` indipendentemente dalla cartella in cui ti trovi.

**Suggerimento** Se vuoi richiamare il comando `laradhoc`  quando ti trovi nella cartella del tuo progetto Laravel,
definisci un alias `alias laradhoc='../bin/laradhoc'` (ad esempio nel tuo file `.bashrc`).

Così facendo, quando nel terminale ti trovi nella cartella principale del tuo progetto Laravel, puoi semplicemente
digitare `laradhoc` (come se il binario fosse nella stessa cartella).

## Configurazione

### .env

Crea il file `.env` a partire da `.env.example`

```bash
cp .env.example .env

# Personalizza ogni variabile in base alle tue esigenze.
# Leggi i commenti in corrispondenza di ciascuna variabile nel file .env.example. 
```

### Dominio personalizzato

In base al valore della variabile `${APP_HOST}`, aggiungi il tuo dominio (es. `laradhoc.test`) al tuo file hosts

```bash
sudo /bin/bash -c 'echo -e "127.0.0.1 laradhoc.test" >> /etc/hosts'
```

### HTTPS

Scegli se vuoi eseguire la tua applicazione sotto HTTP o HTTPS.

* HTTPS: imposta `NGINX_ENABLE_HTTPS=1`
* HTTP: imposta `NGINX_ENABLE_HTTPS=0`

Con HTTPS abilitato, verrà generato un certificato SSL auto-firmato.

Sotto `.docker/images/nginx/ssl` troverai due file:

* `${APP_HOST}.test.crt`
* `${APP_HOST}.test.key`

NOTA: è necessario importare il file `.crt` in modo che venga ritenuto *affidabile*
dal tuo sistema operativo / browser.

### Si parte

Esegui la *build* di tutti i container Docker e avviali

```bash
 ./bin/laradhoc init
```

---

Ok, ora parliamo della tua applicazione Laravel!

Devi crearne una nuova da zero o usarne una esistente?

### a. Nuova applicazione

Progetto Laravel nuovo di zecca? Nessun problema! Esegui:

```bash
./bin/laradhoc install-laravel
```

Un'applicazione Laravel fresca fresca verrà scaricata in `${APP_SRC}`, configurata e disponibile
all'indirizzo [http://${APP_HOST}]()
o [https://${APP_HOST}]()

### b. Applicazione esistente

Devi lavorare con un progetto Laravel esistente?

Copialo o clonalo in `${APP_SRC}` in modo che la tua applicazione Laravel risieda in quella cartella.

Quindi lancia:

```bash
./bin/laradhoc init-laravel
```

Laradhoc proverà a cercare il file `.env` (se non lo trova, lo copierà da `.env.example`). Quindi, aggiornerà il
file `.env` della tua applicazione Laravel con i valori presi dal file `.env` principale. Infine, installerà le
dipendenze Composer e una chiave verrà generata dal solito comando Artisan.

---

Ricordati di eseguire le tue migration e gli eventuali seed:

```bash
./bin/laradhoc artisan migrate --seed
```

Infine, occupati di tutto ciò che è richiesto dalla tua applicazione Laravel per poter essere eseguita correttamente. Ad
esempio:

* `./bin/laradhoc artisan passport:install --force`
* `./bin/laradhoc node npm install && ./bin/laradhoc node npm run dev`
* ecc.

--- 

Stufo di lavorare? Ferma tutto:

```bash
./bin/laradhoc stop
```

La prossima volta che hai bisogno di eseguire la tua applicazione, se non hai modificato nulla a livello di
configurazione Docker, esegui

```bash
./bin/laradhoc start
```

<b>N.B.</b> Nginx eseguirà il proxy di tutte le richieste dirette a `socket.io` verso il container `laravel-echo`.

## Aggiornamenti

Quando esegui l'aggiornamento a partire da una versione precedente, segui questi passaggi:

- aggiorna il tuo codice
    - via `git pull` se punti ancora a questo repository, un fork o un repo privato
    - manualmente, scaricando la [release](https://github.com/eleftrik/laradhoc/releases) che ti occorre

  In entrambi i casi, la cartella `src/` non verrà coinvolta
- consulta `CHANGELOG.md`
- aggiorna il tuo file `./.env` confrontandolo con `./.env.example`
  (nuove variabili potrebbero essere state introdotte)
- se hai sovrascritto `docker-compose.yml` tramite `docker-compose.override.yml`, consulta
  `docker-compose.yml` per verificare se qualcosa è stato aggiunto, modificato o eliminato, confrontando con la
  precedente versione del file `docker-compose.yml` che stavi usando prima di effettuare l'aggiornamento
- esegui `./bin/laradhoc start --build`

## Script

Laradhoc fornisce alcuni comodi script, situati nella cartella `.docker/scripts`.

Eseguili dalla cartella base in cui hai collocato Laradhoc.

### init

```bash
./bin/laradhoc init
```

Si occupa di

* verificare che `openssl` sia installato sulla tua macchina (se hai impostato `NGINX_ENABLE_HTTPS=1`)
* creare un certificato auto-generato (se hai impostato `NGINX_ENABLE_HTTPS=1`)
* eseguire la *build* dei container ed avviarli

### start | up

```bash
./bin/laradhoc start
```

oppure

```bash
./bin/laradhoc up
```

E' una scorciatoia per

```bash
docker-compose up -d
```

Puoi utilizzare il flag `--build` se vuoi eseguire la *build* dei container, altrimenti

```bash
./bin/laradhoc start
```

è sufficiente per tirare su l'ambiente di sviluppo

### build

Se vuoi (ri)costruire le immagini, lancia

```bash
./bin/laradhoc build
```

### stop | down

Stanco di lavorare?

```bash
./bin/laradhoc stop
```

oppure

```bash
./bin/laradhoc down
```

### install-laravel

Utile per tirare su un nuovo progetto Laravel da zero. Rende disponibile una nuova installazione di Laravel nella
cartella `${APP_SRC}`, quindi crea un file `${APP_SRC}/.env` contenente gli stessi valori presenti nel file `.env`
principale.

```bash
./bin/laradhoc install-laravel
```

### init-laravel

Aggiorna il file `.env` usato da Laravel utilizzando i valori delle variabili presenti nel file `.env` principale

```bash
./bin/laradhoc init-laravel
```

### artisan

Esegue un comando *artisan* all'interno del container `php-fpm`. Esempio:

```bash
./bin/laradhoc artisan make:migration create_example_table
``` 

### composer

Esegue un comando *composer* all'interno del container `composer`. Esempio:

```bash
./bin/laradhoc composer install
``` 

### node

Esegue un comando attraverso il container `node`. Esempio:

```bash
./bin/laradhoc node yarn run production
``` 

### gulp

Hai bisogno di far girare un vecchio progetto che utilizza ancora `gulp`? Nessun problema: questo script esegue Gulp e
compila i tuoi *asset*.

Esempio:

```bash
./bin/laradhoc gulp watch
``` 

### test

Esegue i test tramite PHPUnit:

```bash
./bin/laradhoc test
``` 

### ps

Mostra i container in esecuzione, sulla base di quanto definito nel file docker-compose:

```bash
./bin/laradhoc ps
``` 

E' un sinonimo di

```bash
docker-compose ps
``` 

### nah

Vuoi far fuori **tutto**? Questo comando ferma tutti i container, cancella i volumi Docker e l'intera
cartella `$APP_SRC`.

Per cui, prima di eseguirlo, **ASSICURATI** di aver compreso davvero bene che perderai tutta la tua *codebase* Laravel e
il relativo database!

```bash
./bin/laradhoc nah
```

Per far fuori tutto e ripartire da zero, esegui

```bash
./bin/laradhoc nah && ./bin/laradhoc init && ./bin/laradhoc laravel-install
```

### help

Questo comando mostra un breve aiuto, elencando i comandi disponibili:

```bash
./bin/laradhoc help
``` 

## Accedere al database MySQL/MariaDB

### Via phpMyAdmin

Puoi utilizzare phpMyAdmin: [http://${APP_HOST}:${PHPMYADMIN_PORT}]()

Ad esempio: [http://laradhoc.test:8080]()

### Via applicazione

Puoi connetterti al tuo database via riga di comando o utilizzando un'applicazione.

Per esempio, da riga di comando:

```bash
source .env
mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -h127.0.0.1 $MYSQL_DATABASE
```

Però scommetto che preferisci utilizzare la tua applicazione preferita, ad esempio:

- TablePlus
- SequelPro
- HeidiSQL

ecc.

Utilizza i parametri presenti nel tuo file `.env`.

## Accedere a MongoDB

La porta sulla quale MongoDB è in ascolto è la 27017.

Nei seguenti esempi, chiaramente devi sostituire
`user`, `password` e `laradhoc` con gli attuali valori delle variabili di ambiente
`MONGODB_USER`, `MONGODB_PASSWORD` e `MONGODB_DATABASE`.

Se sul tuo host è presente il client da riga di comando *mongo*, puoi accedere tramite CLI:

```shell script
mongo -u user -p password laradhoc
```

Oppure puoi utilizzare un'applicazione, inserendo come stringa di connessione

`mongodb://user:password@localhost/laradhoc`

## MailHog

Per "acchiappare" tutte le mail in uscita utilizzando MailHog, configura il file `.env` usato da Laravel con questi
parametri:

```dotenv
MAIL_HOST=mailhog
MAIL_PORT=1025
MAIL_USERNAME=
MAIL_PASSWORD=
```

L'interfaccia web di MailHog è disponibile all'indirizzo

[http://${APP_HOST}:${MAILHOG_PORT}]()

Per esempio: [http://laradhoc.test:8081]()

## Collaborazioni

Suggerimenti, revisioni, segnalazioni di bug sono i benvenuti. Non si smette mai di imparare :-)

Le *pull request* sono ben accette. Per modifiche più sostanziose, prima apri un *issue* per spiegare cosa vorresti
modificare.

## Ringraziamenti

Un ringraziamento a

- [Mauro Cerone](https://github.com/ceronem)
- Sail by [Taylor Otwell](https://github.com/taylorotwell)

per l'ispirazione

## License

[MIT](https://choosealicense.com/licenses/mit/)
