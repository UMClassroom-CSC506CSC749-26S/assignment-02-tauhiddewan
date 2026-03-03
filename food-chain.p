%types
tff(species_type, type, species:$tType).
tff(foodlink_type, type, foodlink:$tType).

%functions
tff(eaten_decl, type, eaten: foodlink > species).
tff(eater_decl, type, eater: foodlink > species).

%predicates
tff(eats_decl, type, eats: (species*species) > $o).
tff(primary_producer_decl, type, primary_producer: species > $o).
tff(apex_predator_decl, type, apex_predator: species > $o).
tff(depends_on_decl, type, depends_on: (species*species) > $o).


%Axiom1: The eater of a food link eats the eaten of the link.
tff(eater_eats_eaten, axiom, 
    ![L:foodlink] : (
        eats(eater(L), eaten(L))
    )
).

%Axiom2:The eaten and eater of a food link are not the same (no cannibalism).
tff(eater_eaten_not_same, axiom, 
    ![L:foodlink] : (
        eater(L) != eaten(L)
    )
).

%Axiom3: Every species eats something or is eaten by something (or both).
tff(eats_or_eaten, axiom, 
    ! [S:species] : (
        (? [P1:species]: eats(S, P1)) | 
        (? [P2:species]: eats(P2, S))
    )
).

%Axiom4: Something is a primary producer iff it eats no other species.
tff(something_primary_producer, axiom, 
    ! [S:species] : (
        primary_producer(S) <=> ![X:species] : ~eats(S, X)
    )
).

%Conjecture1: If something is a primary producer 
%then there is no food link such that the primary producer is the eater of the food link.
tff(primary_producer_not_eater_of_foodchain, conjecture, 
    ! [S:species] : (
        primary_producer(S) => ~?[L:foodlink]: (eater(L) => S)
    )
).


%Conjecture2: Every primary producer is eaten by some other species.
tff(primary_producer_eaten_by_other, conjecture, 
    ! [S:species] : ( 
        primary_producer(S) => ? [P:species] : (
            eats(P, S) & P !=S
        )
    )
).