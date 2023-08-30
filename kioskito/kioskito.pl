%1

atiende(dodain,lunes,horario(9,15)).
atiende(dodain,miercoles,horario(9,15)).
atiende(dodain,viernes,horario(9,15)).
atiende(lucas,martes,horario(10,20)).
atiende(juanC,sabados,horario(18,22)).
atiende(juanC,domingos,horario(18,22)).
atiende(juanFdS,jueves,horario(10,20)).
atiende(juanFdS,viernes,horario(12,20)).
atiende(leoC,lunes,horario(14,18)).
atiende(leoC,miercoles,horario(14,18)).
atiende(martu,miercoles,horario(23,24)).

atiende(vale,Dia,Horario) :- atiende(dodain,Dia,Horario).
atiende(vale,Dia,Horario) :- atiende(juanC,Dia,Horario).

%justificacion para item 2 y 3, no hago nada por el principio de universo cerrado. si no existe es falso!!!

%%%%%%%%% 2 %%%%%%%%%%

quienAtiende(Persona,Dia,Hora) :-
    atiende(Persona,Dia,horario(HoraInicio,HoraFinalizacion)),
    Hora >= HoraInicio, Hora =< HoraFinalizacion.

%%%%%%%%% 3 %%%%%%%%%%

foreverAlone(Persona,Dia,Hora) :-
    atiende(Persona,_,_), atiende(Persona2,_,_),
    quienAtiende(Persona,Dia,Hora),
    not(quienAtiende(Persona2,Dia,Hora)).

%%%%%%%%% 4 %%%%%%%%%%

posibilidadesDeAtencion(Dia,Personas) :-
    atiende(_,Dia,_),
    findall(Persona,atiende(Persona,Dia,_),PersonasPosibles),
    combinacionTurnos(PersonasPosibles,Personas).


combinacionTurnos([],[]).
combinacionTurnos([PersonaPosible|PersonasPosibles],[Persona|PersonasRestantes]) :-
    combinacionTurnos(PersonasPosibles, PersonasRestantes).
combinacionTurnos([_|PersonasPosibles],[Persona|PersonasRestantes]) :-
    combinacionTurnos(PersonasPosibles, PersonasRestantes).

     
%%%%%%%%% 5 %%%%%%%%%%

vendio(dodain,dia(10,8),golosina(1200)).
vendio(dodain,dia(10,8),cigarrilos([jockey])).
vendio(dodain,dia(10,8),golosina(50)).
vendio(dodain,dia(12,8),bebida(8,alcoholica)).
vendio(dodain,dia(12,8),bebida(1,noAlcoholica)).
vendio(dodain,dia(12,8),golosinas(10)).
vendio(martu,dia(12,8),golosinas(1000)).
vendio(martu,dia(12,8),cigarrillos([chesterfield,colorado,parissiennes])).
vendio(lucas,dia(11,8),golosinas(600)).
vendio(lucas,dia(18,8),bebida(2,noAlcoholicas)).
vendio(lucas,dia(18,8),cigarrillos(derby)).

esSuertuda(Persona) :- 
    vendio(Persona,_,_),
    vendio(Persona,_,Articulo),
    esImportante(Articulo).

esImportante(golosina(Precio)) :-
    Precio > 100.

esImportante(cigarrillos(Marcas)) :-
    length(Marcas, CantidadMarcas),
    CantidadMarcas >= 2.

esImportante(bebida(_,alcoholica)).

esImportante(bebida(Cantidad,_)) :-
    Cantidad >= 5.


    