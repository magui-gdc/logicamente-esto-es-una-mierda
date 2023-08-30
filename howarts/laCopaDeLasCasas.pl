%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parte 2 - La copa de las casas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

esDe(hermione, gryffindor). 
esDe(ron, gryffindor). 
esDe(harry, gryffindor). 
esDe(draco, slytherin). 
esDe(luna, ravenclaw).

acciones(harry, salirDeLacama).
acciones(hermione, irAlTercerPiso).
acciones(hermione, irALABiblioRestringida).
acciones(harry, irAlBosqueProhibido).
acciones(harry, irAlTercerPiso).
acciones(draco, irALasMazmorras).
acciones(ron, ganarAjedrezMagico).
acciones(hermione, salvarAmigos).
acciones(harry, vencerVoldemort).


puntajeAcciones(salirDeLacama,0).
puntajeAcciones(irALasMazmorras,0).
puntajeAcciones(irAlBosqueProhibido,-50).
puntajeAcciones(irALABiblioRestringida,-10).
puntajeAcciones(irAlTercerPiso,-75).
puntajeAcciones(ganarAjedrezMagico,50).
puntajeAcciones(salvarAmigos,50).
puntajeAcciones(vencerVoldemort,60).


%1

esBuenAlumno(Mago) :-
    esDe(Mago,_),
    forall(acciones(Mago,Accion), (puntajeAcciones(Accion,Puntaje), Puntaje >= 0)).

accionRecurrente(Accion) :-
    acciones(_,Accion),
    acciones(Mago1,Accion), acciones(Mago2,Accion),
    Mago1 \= Mago2.

%2

puntajeTotalCasa(Casa,Puntaje) :-
    esDe(_,Casa),
    findall(Puntaje,(esDe(Mago,Casa),acciones(Mago,Accion),puntajeAcciones(Accion,Puntaje)), Puntajes),
    sumlist(Puntajes, Puntaje).
    
%3

casaGanadora(Casa) :-
    esDe(_,Casa),
    findall(Casa,esDe(_,Casa),Casas)
    sort(Casas,)

    
    



    



    

    