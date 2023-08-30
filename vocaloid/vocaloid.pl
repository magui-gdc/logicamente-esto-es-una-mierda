%%%%% declaraciones iniciales %%%%%

sabeCantar(megurineLuka,cancion(nightFever,4)).
sabeCantar(megurineLuka,cancion(foreverYoung,5)).
sabeCantar(hatsuneMiku,cancion(tellYourWorld,4)).
sabeCantar(gumi,cancion(foreverYoung,4)).
sabeCantar(gumi,cancion(tellYourWorld,5)).
sabeCantar(seeU,cancion(novemberRain,6)).
sabeCantar(seeU,cancion(nightFever,5)).

vocaloid(Vocaloid) :- sabeCantar(Vocaloid,_).

%%%%% 1 %%%%%

esNovedoso(Vocaloid) :-
    vocaloid(Vocaloid),
    seSabeMasDeDos(Vocaloid),
    menosDe15MinutosTotales(Vocaloid).

seSabeMasDeDos(Vocaloid) :-
    sabeCantar(Vocaloid,Cancion1),
    sabeCantar(Vocaloid,Cancion2),
    Cancion1 \= Cancion2.

menosDe15MinutosTotales(Vocaloid) :-
    cantidadMinutosTotales(Vocaloid,MinutosTotales),
    MinutosTotales < 15.

cantidadMinutosTotales(Vocaloid,MinutosTotales) :-
    findall(Minutos, (sabeCantar(Vocaloid,Cancion),tiempoCancion(Cancion, Minutos)), ListaMinutos),
    sumlist(ListaMinutos, MinutosTotales).

tiempoCancion(cancion(_,Tiempo),Tiempo).

%%%%% 2 %%%%%%

esCantanteAcelerado(Vocaloid) :-
    vocaloid(Vocaloid),
    not((sabeCantar(Vocaloid,Cancion), tiempoCancion(Cancion,Minutos),Minutos>4)).

%%%%% conciertos %%%%%

concierto(mikuExpo, 2000, gigante(2,6), eeuu).
concierto(magicalMirai, 3000, gigante(3,10), japon).
concierto(vocalektVisions, 1000, mediano(9), eeuu).
conciertos(mikuFest, 100, chiquito(4), argentina).

%%%%% 2 %%%%%

puedeParticipar(hatsuneMiku,_).
puedeParticipar(Vocaloid,Concierto) :-
    vocaloid(Vocaloid),
    concierto(Concierto,_,Requisitos,_),
    cumpleRequisitos(Vocaloid,Requisitos).

cumpleRequisitos(Vocaloid,gigante(CantMinimaCanciones,DuracionTotalCanciones)) :-
    cantCancionesQueSabe(Vocaloid,CantCancionesQueSabe),
    CantCancionesQueSabe >= CantMinimaCanciones,
    cantidadMinutosTotales(Vocaloid,MinutosTotales),
    MinutosTotales > DuracionTotalCanciones.

cumpleRequisitos(Vocaloid,mediano(DuracionTotalCanciones)) :-
    cantidadMinutosTotales(Vocaloid,MinutosTotales),
    MinutosTotales < DuracionTotalCanciones.

cumpleRequisitos(Vocaloid,chiquito(DuracionTotalCanciones)) :-
    sabeCantar(Vocaloid,Cancion), 
    tiempoCancion(Cancion,Minutos),
    Minutos > DuracionTotalCanciones.

cantCancionesQueSabe(Vocaloid,CantCancionesQueSabe) :-
    findall(Cancion, sabeCantar(Vocaloid,Cancion), ListaCanciones),
    length(ListaCanciones, CantCancionesQueSabe).
    
%%%%% 3 %%%%%

elMasFamoso(Vocaloid) :- 
    vocaloid(Vocaloid),
    fama(Vocaloid,FamaMayor),
    forall(fama(_,Fama),FamaMayor>=Fama).

fama(Vocaloid,Fama) :-
    vocaloid(Vocaloid),
    famaOtorgadaPorConciertos(Vocaloid, FamaOtorgadaPorConciertos),
    cantCancionesQueSabe(Vocaloid,CantCancionesQueSabe),
    Fama is FamaOtorgadaPorConciertos * CantCancionesQueSabe.
    
famaOtorgadaPorConciertos(Vocaloid, FamaOtorgadaPorConciertos) :-
    vocaloid(Vocaloid),
    findall(Fama, (puedeParticipar(Vocaloid,Concierto),concierto(Concierto,Fama,_,_)),ListaFamaConciertos),
    sumlist(ListaFamaConciertos,FamaOtorgadaPorConciertos).

%%%%% 4 %%%%%

seConoce(megurineLuka,hatsuneMiku).
seConoce(megurineLuka,gumi).
seConoce(gumi,seeU).
seConoce(seeU,kaito).

esElUnicoQueParticipa(Vocaloid,Concierto) :-
    puedeParticipar(Vocaloid,Concierto),
    not((seConoce(Vocaloid,OtroVocaloid),puedeParticipar(OtroVocaloid,Concierto))).

seConocen(Vocaloid1,Vocaloid2) :-
    seConoce(Vocaloid1,Vocaloid2).

seConocen(Vocaloid1,Vocaloid2) :-
    seConoce(Vocaloid1,OtroVocaloid),
    seConocen(OtroVocaloid,Vocaloid2).
    


