build_kb:-
      write('Please enter a word and its category on separate lines:') ,nl,
      read(W),
      (W==done ,
       write('Done building the words database'),assert(word(W,W));
       W\=done ,
       read(C),
       assert(word(W,C)),build_kb).



categories(L):- 
       setof(C,is_category(C),L).

is_category(C):-
        word(X,C),X\=done.



available_length(L):-
              word(X,Y),atom_length(X,L),X\=done.





pick_word(W,L,C):-
              word(X,C),atom_length(X,L),W=X.




correct_letters([],_,[]).
correct_letters([H|T1],L2,[H|T2]):-
            member(H,L2),correct_letters(T1,L2,T2).
correct_letters([H|T1],L2,L):-
            \+member(H,L2),correct_letters(T1,L2,L).




correct_positions([],_,[]).
correct_positions([H|T1],[H|T2],[H|T3]):-
                correct_positions(T1,T2,T3).
correct_positions([H1|T1],[H2|T2],L3):-
                H1\=H2,correct_positions(T1,T2,L3).


	
takelength(X):-
    setof(L,available_length(L),X).

	

takecat(G):-
     read(C),categories(L),(\+member(C,L),write("This category does not exist"),nl,write("choose a category"),nl,takecat(X);
	 member(C,L),G=C).     
	 
	 
checklength(Z,G):-
      write("Choose a Length:"),nl,read(Length),takelength(X),((member(Length,X),word(E,G),atom_length(E,Length),Z=Length);
	  (\+member(Length,X),write("There are no words of this length"),nl,checklength(Z,G));(member(Length,X),word(E,K),K\=G,
	  write("There are no words of this length"),nl,checklength(Z,G))).  

	 
	 
takeword(W,Z):-
     write("Enter a word composed of "), write(Z),write(" letters:"),nl,
	 read(I),atom_length(I,L),(L\=Z,write("word not composed of "),write(Z),write(" letters . Try again."),nl, write("Remaining Guesses are "),
     N is Z+1, write(N),nl,takeword(M,Z);Z==L,W=I).     
	 

	  

checkword(_,1):-write("you lost!"),!.  

checkword(W,Count):-
      atom_chars(W,List1),word(X,C),atom_chars(X,List2),X==W,Count\=1,write("you win!"),!.
	  
checkword(W,Count):-
      Count\=1,atom_chars(W,List1),word(X,C),atom_chars(X,List2),length(List1,L1),length(List2,L2),L1==L2,correct_letters(List1,List2,List3),write("Correct Letters are: "),write(List3),
	  correct_positions(List1,List2,List4),nl,write("Correct letters in correct positions are: "),write(List4),
	  M is Count-1 ,nl,write("Remaining Guesses are "),write(M),nl,K=L1,takeword(R,K),checkword(R,M).
	  

        
play:-
   write("The available categories are: "),categories(L),write(L),nl,
   write("choose a category"),nl,takecat(G),
   checklength(Z,G),nl,write("Game started . you have ")
   ,Z1 is Z+1,write(Z1),write(" guesses"),nl,takeword(H,Z),checkword(H,Z1).
   
   
   
main:-
   write("Welcome to Pro-Wordle!"),nl,build_kb,nl,play.




