%% Punto1
%% puesto(Comida, precio)
puesto(hamburguesa, 2000).
puesto(panchitoConPapas, 1500).
puesto(lomitoCompleto, 2500).
puesto(caramelos, 0).

%% atraccion(nombre, tipo)
atraccion(autitosChocadores, tranquila(paraTodos)).
atraccion(casaEmbrujada, tranquila(paraTodos)).
atraccion(laberinto, tranquila(paraTodos)).
atraccion(tobogan, tranquila(paraChicos)).
atraccion(calesita, tranquila(paraChicos)).
atraccion(barcoPirata, intensa(14)).
atraccion(tazasChinas, intensa(6)).
atraccion(simulador3D, intensa(2)).
atraccion(abismoMortalRecargada, montaniaRusa(3, 134)).
atraccion(paseoPorElBosque, montaniaRusa(0, 45)).
atraccion(elTorpedoSalpicon, acuatica).
atraccion(esperoQueHayasTraidoUnaMudaDeRopa, acuatica).

%%datos(Nombre, superficiales(Dinero, Edad, GrupoFamiliar), sentimientos(Hambre, Aburrrimiento))
datos(eusebio, superficiales(3000, 80, viejitos), sentimientos(50,0)).
datos(carmela, superficiales(0, 80, viejitos), sentimientos(0, 25)).

%% Punto2
estadoDeBienestar(Persona, Estado) :-
    sumaDeBienestar(Persona, Suma),
    cuantosLoAcompanian(Persona, Familiares),
    clasificacionDeBienestar(Suma, Familiares, Estado).

clasificacionDeBienestar(0, Familiares, felicidadPlena) :-
    Familiares >= 1.

clasificacionDeBienestar(0, 0, podriaEstarMejor).

clasificacionDeBienestar(Suma, _, podriaEstarMejor) :-
    between(1, 50, Suma).

clasificacionDeBienestar(Suma, _, necesitaEntretenerse) :-
    between(51, 99, Suma).

clasificacionDeBienestar(Suma, _, seQuiereIrACasa) :-
    Suma >= 100.

cuantosLoAcompanian(Persona, Cantidad) :-
    findall(Familiar,familiarPersona(Persona, Familiar), Familiares),
    length(Familiares, Cantidad).

familiarPersona(Persona, Familiar) :-
    familiaPersona(Persona, Familia),
    familiaPersona(Familiar, Familia),
    Persona \= Familiar.

familiaPersona(Persona, Familia) :-
    datos(Persona, superficiales(_, _, Familia), _).

sumaDeBienestar(Persona, Suma) :-
    sentimientos(Persona, Hambre, Aburrimiento),
    Suma is Hambre + Aburrimiento.

sentimientos(Persona, Hambre, Aburrimiento) :-
    datos(Persona, _, sentimientos(Hambre, Aburrimiento)).


%% Punto3
satisfaceHambreFamilia(Familia, Comida) :-
    familiaPersona(_, Familia),
    puesto(Comida, _),
    forall(familiaPersona(Persona, Familia), pagableYLlena(Comida, Persona)).

pagableYLlena(Comida, Persona) :-
    puedePagar(Persona, Comida),
    satisfaceHambrePersona(Comida, Persona).

satisfaceHambrePersona(hamburguesa, Persona) :-
    sentimientos(Persona, Hambre, _),
    Hambre < 50.

satisfaceHambrePersona(panchitoConPapas, Persona) :-
    esChico(Persona).

satisfaceHambrePersona(lomitoCompleto, Persona) :-
    datos(Persona, _, _).

satisfaceHambrePersona(caramelos, Persona) :-
    noLeAlcanzaParaOtra(Persona).

noLeAlcanzaParaOtra(Persona) :-
    forall(comidaConCosto(Comida, _), not(puedePagar(Persona, Comida))).

puedePagar(Persona, Comida) :-
    dineroPersona(Persona, Dinero),
    puesto(Comida, Costo),
    Dinero >= Costo.

dineroPersona(Persona, Dinero) :-
    datos(Persona, superficiales(Dinero,_, _), _).

comidaConCosto(Comida, Costo) :-
    puesto(Comida, Costo),
    Costo > 0.

esChico(Persona) :-
    edadPersona(Persona, Edad),
    Edad < 13.

edadPersona(Persona, Edad) :-
    datos(Persona, superficiales(_, Edad, _), _).

%% Punto4
lluviaDeHamburguesas(Persona, Atraccion) :-
    puedePagar(Persona, hamburguesa),
    eligeAtraccionQueTraeLluvia(Persona, Atraccion).

eligeAtraccionQueTraeLluvia(_, Atraccion) :-
    atraccion(Atraccion, intensa(Coeficiente)),
    Coeficiente > 10.

eligeAtraccionQueTraeLluvia(Persona, Montania) :-
    atraccion(Montania, Caracteristicas),
    peligrosaSegunPersona(Caracteristicas, Persona).

eligeAtraccionQueTraeLluvia(tobogan, Chico) :-
    esChico(Chico).

peligrosaSegunPersona(_, Chico) :-
    esChico(Chico).

peligrosaSegunPersona(CaracteristicasMontania, Persona) :-
    not(esChico(Persona)),
    not(estadoDeBienestar(Persona, necesitaEntretenerse)),
    montaniaConMasGiros(CaracteristicasMontania).

montaniaConMasGiros(montania(GirosMaximos, _)) :-
    forall(atraccion(_, montania(Giros,_)), Giros =< GirosMaximos).

%% Punto5
opcionEntretenimientoParaPersona(Persona, Opcion, Mes) :-
    datos(Persona, _ , _),
    member(Mes, [enero, febrero, marzo, abril, mayo, junio, julio, agosto, septiembre, octubre, noviembre, diciembre]),
    esOpcion(Persona, Opcion, Mes).

esOpcion(_, Acuatica, Mes) :-
    member(Mes, [septiembre, octubre, noviembre, diciembre, enero, febrero, marzo]),
    atraccion(Acuatica, acuatica).

esOpcion(Persona, puestoDe(Comida, Precio), _) :-
    puesto(Comida, Precio),
    puedePagar(Persona, Comida).

esOpcion(_, Intensa, _) :-
    atraccion(Intensa, intensa(_)).

esOpcion(Persona, Montania, _) :-
    atraccion(Montania, CaracteristicasMontania),
    not(peligrosaSegunPersona(CaracteristicasMontania, Persona)).

esOpcion(Persona, TranquilaChicos, _) :-
    esChico(Persona),
    atraccion(TranquilaChicos, tranquila(paraChicos)).

esOpcion(_, TranquilaTodos, _) :-
    atraccion(TranquilaTodos, tranquila(paraTodos)).

esOpcion(Persona, TranquilaChicos, _) :-
    not(esChico(Persona)),
    atraccion(TranquilaChicos, tranquila(paraChicos)),
    familiarPersona(Persona, Chico),
    esChico(Chico).




    



