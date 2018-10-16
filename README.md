# Lade Appen
Av Hågen og Ludvig Ellevold

[![Build Status](https://travis-ci.com/ljellevo/lade-appen.svg?token=4vRybCsr2qhs6ApMwxt1&branch=master)](https://travis-ci.com/ljellevo/lade-appen)


Legge til bruker under subscription/{stationId}/members_subscription/{uid:timestamp}

Legge til stasjon under user_info/{uid}/subscriptions/{stationId}/{from:timestamp
 to: timestamp + duration}

Må modifisere backend. Den må oppdatere __update__ feltet under user_info/{uid}/subscriptions/{stationId}/

    {
    update: timestamp
    from: timestamp
    to: timestamp + duration
    }

Dersom update er større en __"to"__ feltet så sendes det ikke noen notifikasjon og den blir slettet fra databasen.