% ciudad_id: identificador de la ciudad
ciudad_id(1,'A').
ciudad_id(2,'B').
ciudad_id(3,'C').
ciudad_id(4,'D').
ciudad_id(5,'E').
ciudad_id(6,'F').
ciudad_id(7,'G').
ciudad_id(8,'H').
ciudad_id(9,'I').
ciudad_id(10,'J').
ciudad_id(11,'K').
ciudad_id(12,'L').
ciudad_id(13,'M').
ciudad_id(14,'N').
ciudad_id(15,'O').

% Distancia real entre las ciudades conectadas
arista_dist(1,2,14).
arista_dist(1,3,15).
arista_dist(1,9,37).
arista_dist(2,3,16).
arista_dist(2,4,7).
arista_dist(3,9,17).
arista_dist(3,10,17).
arista_dist(4,5,8).
arista_dist(4,7,7).
arista_dist(5,7,8).
arista_dist(5,10,11).
arista_dist(5,12,15).
arista_dist(6,7,7).
arista_dist(6,8,7).
arista_dist(6,12,15).
arista_dist(6,14,17).
arista_dist(8,14,9).
arista_dist(9,10,22).
arista_dist(9,15,22).
arista_dist(10,11,9).
arista_dist(11,12,23).
arista_dist(11,13,21).
arista_dist(11,15,14).
arista_dist(12,13,13).
arista_dist(12,14,14).
arista_dist(13,14,13).


% Heurística: distancia recta de una ciudad a otra
dist_recta(1,5,30).
dist_recta(2,5,10).
dist_recta(3,5,20).
dist_recta(4,5,5).
dist_recta(5,5,0).
dist_recta(6,5,10).
dist_recta(7,5,5).
dist_recta(8,5,20).
dist_recta(9,5,25).
dist_recta(10,5,10).
dist_recta(11,5,15).
dist_recta(12,5,10).
dist_recta(13,5,20).
dist_recta(14,5,20).
dist_recta(15,5,25).


cargar(A):-exists_file(A),consult(A).

obtener_dist_recta(Origen, Destino, Dist):-
	dist_recta(Origen, Destino, Dist).
#obtener_dist_recta(Origen, Destino, Dist):-
	#!,
	#dist_recta(Destino, Origen, Dist).


% Devuelve todas las rutas asociadas
buscarRuta(Origen, Destino,Ruta,N):-
	ciudad_id(C1,Origen),
	ciudad_id(C2,Destino),
	buscarHeuristica([[0,C1]],RutaInvertido,C2,N),
	invertirRuta(RutaInvertido, Ruta).
	
	%imprimirRuta(Ruta).
buscarRuta(_,_,_):-
	write('Ruta invalida').


% condición de parada de búsqueda de heurística
buscarHeuristica(Rutas, [Costo,Destino|Ruta], Destino,1):-
	member([Costo,Destino|Ruta],Rutas),
	escogerProximo(Rutas, [Costo1|_], Destino),
	Costo1 == Costo.

buscarHeuristica(Rutas, Solucion, Destino,N):-
	escogerProximo(Rutas, Prox, Destino),
	removerRuta(Prox, Rutas, RutasRestantes),
	extenderSiguienteRuta(Prox, NuevosRutas),
	concatenarRutas(RutasRestantes, NuevosRutas, ListaCompleta),
	Ni is N,
	buscarHeuristica(ListaCompleta, Solucion, Destino,Ni).

% Obtener rutas y comparar
escogerProximo([X],X,_):-
	!.
escogerProximo([[Costo1,Ciudad1|Resto1],[Costo2,Ciudad2|_]|Cola], MejorRuta, Destino):-
	obtener_dist_recta(Ciudad1, Destino, Evaluacion1),
	obtener_dist_recta(Ciudad2, Destino, Evaluacion2),
	Evaluacion1 +  Costo1 =< Evaluacion2 +  Costo2,
	escogerProximo([[Costo1,Ciudad1|Resto1]|Cola], MejorRuta, Destino).
escogerProximo([[Costo1,Ciudad1|_],[Costo2,Ciudad2|Resto2]|Cola], MejorRuta, Destino):-
	obtener_dist_recta(Ciudad1, Destino, Evaluacion1),
	obtener_dist_recta(Ciudad2, Destino, Evaluacion2),
	Evaluacion1  + Costo1 > Evaluacion2 +  Costo2,
	escogerProximo([[Costo2,Ciudad2|Resto2]|Cola], MejorRuta, Destino).

extenderSiguienteRuta([Costo,No|Camino],NuevosCaminos):-
	findall([Costo,NuevoNo,No|Camino], (verificarMovimiento(No, NuevoNo,_),not(member(NuevoNo,Camino))), ListaResultante),
	actualizarCostosRutas(ListaResultante, NuevosCaminos).

% Actualizacion de los costos de los Rutas
actualizarCostosRutas([],[]):-!.
actualizarCostosRutas([[Costo,NuevoNo,No|Camino]|Cola],[[NuevoCosto,NuevoNo,No|Camino]|Cola1]):-
	verificarMovimiento(No, NuevoNo, Dist),
	NuevoCosto is Costo + Dist,
	actualizarCostosRutas(Cola,Cola1).


verificarMovimiento(Origen, Destino, Dist):-
	arista_dist(Origen, Destino, Dist).
verificarMovimiento(Origen, Destino, Dist):-
	arista_dist(Destino, Origen, Dist).
 
invertirRuta([X],[X]).
invertirRuta([X|Y],Lista):-
	invertirRuta(Y,ListaInt),
	concatenarRutas(ListaInt,[X],Lista).

concatenarRutas([],L,L).
concatenarRutas([X|Y],L,[X|Lista]):-
	concatenarRutas(Y,L,Lista).


removerRuta(X,[X|T],T):-
	!.
removerRuta(X,[Y|T],[Y|T2]):-
	removerRuta(X,T,T2).


% resultado
imprimeRuta([Costo]):-
	nl,
	write('Dist total: '),
	write(Costo).

imprimeRuta([CiudadActual|Cola]):-
	ciudad_id(CiudadActual, X),
	write(X),
	write(', '),
	imprimeRuta(Cola).

imprimirRuta([CiudadActual|Cola]):- 
	write('Ruta: '),
    imprimeRuta([CiudadActual|Cola]).