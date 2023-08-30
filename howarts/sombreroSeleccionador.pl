%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parte 1 - Sombrero Seleccionador
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mago(harry, mestiza).
mago(draco, pura).
mago(hermione, impura).

caracteristicas(harry, coraje).
caracteristicas(harry, amistad).
caracteristicas(harry, orgullo).
caracteristicas(harry, inteligencia).
caracteristicas(draco, inteligencia).
caracteristicas(draco, orgullo).
caracteristicas(hermione, inteligencia).
caracteristicas(hermione, orgullo).
caracteristicas(hermione, responsabilidad).
caracteristicas(hermione, amistad).

casaOdiada(harry, slytherin).
casaOdiada(draco, hufflepuff).

casa(gryffindor).
casa(slytherin).
casa(ravenclaw).
casa(hufflepuff).

caracteristicasParaElegirCasa(gryffindor, coraje).
caracteristicasParaElegirCasa(slytherin, orgullo).
caracteristicasParaElegirCasa(slytherin, inteligencia).
caracteristicasParaElegirCasa(ravenclaw, inteligencia).
caracteristicasParaElegirCasa(ravenclaw, responsabilidad).
caracteristicasParaElegirCasa(hufflepuff, amistad).

tipoDeSangre(Tipo) :- mago(_, Tipo).

nombreMago(Nombre) :- mago(Nombre, _).

% 1

permiteEntrada(Mago, Casa) :- 
    mago(Mago, _),
    casa(Casa),
    condicionParticular(Mago, Casa).

condicionParticular(_, _).
condicionParticular(Mago, slytherin) :-
    not( mago(Mago, impura) ).

%2

tieneCaracterApropiado(Mago, Casa) :-
    mago(Mago,_),
    casa(Casa),
    forall(caracteristicasParaElegirCasa(Casa,Caracteristica), 
    caracteristicas(Mago,Caracteristica)).

%3

queCasaQuedariaSeleccionado(Mago,Casa) :-
    mago(Mago,_),
    casa(Casa),
    permiteEntrada(Mago, Casa), 
    tieneCaracterApropiado(Mago, Casa), 
    not(casaOdiada(Mago,Casa)).
    
queCasaQuedariaSeleccionado(hermione,gryffindor).

%4

cadenaDeAmistades([]). 
cadenaDeAmistades([Mago|Magos]) :-
    mago(Mago,_),
    caracteristicas(Mago,amistad),
    ambosQuedanEnLaMismaCasa(Mago, Magos),
    cadenaDeAmistades(Magos).
  
ambosQuedanEnLaMismaCasa(Mago1, [Mago2|Magos]) :-
    queCasaQuedariaSeleccionado(Mago1, Casa1),
    queCasaQuedariaSeleccionado(Mago2, Casa2),
    Casa1 = Casa2.
 