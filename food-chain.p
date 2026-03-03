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
        primary_producer(S) => ~?[L:foodlink]: (eater(L) = S)
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


%Conjecture3:If a species is not a primary producer then there is another species that it eats.
tff(non_primary_producer_eats_other, conjecture, 
    ! [S:species] : (
        ~primary_producer(S) => ? [P:species] : eats(S,P)
    )
).


%Axiom5: Something is an apex predator iff there is no species that eats it.
tff(apex_predator, axiom, 
    ! [S:species]: (
        apex_predator(S) <=> ~? [P:species] : eats(P, S)
    )
).

%Conjecture4: If something is an apex predator 
%then there is no food link such that the apex predator is the eaten of the food link.
tff(apex_predator_never_gets_eaten, conjecture, 
    ! [S:species] : (
        apex_predator(S) => ? [L:foodlink] : (eaten(L) = S)
    )
).


%Conjecture4: Every apex predator eats some other species.
tff(apex_predator_eats_other, conjecture, 
    ! [S:species] : (
        apex_predator(S) => ? [P:species] : (eats(S, P) & P != S)
    )
).


%Conjecture5: If a species is not a apex predator then there is another species that eats it.
tff(not_apex_predator, conjecture, 
    ! [S:species] : (
        ~apex_predator(S) => ? [P:species] : (eats(P, S) & P != S)
    )
).


% Axiom6: For every food chain, 
% the start of the chain is the eaten of some food link, 
% and one of the following holds: 
%     (i) the eater of the food link is the end of the food chain, xor 
%     (ii) there is a shorter food chain (shorter by one food link) 
%     from the eater of the food link to the end of the whole food chain.

tff(foodchain_type, type, foodchain:$tType).
tff(chain_start_decl, type, chain_start: foodchain > species).
tff(chain_end_decl, type, chain_end: foodchain > species).
tff(shorter_chain_decl, type, shorter_chain: (foodchain * foodchain) > $o).

tff(food_chain, axiom,
    ! [C:foodchain] : ? [L:foodlink] : (
        chain_start(C) = eaten(L) 
        & 
        (
            eater(L) = chain_end(C)
            <~>
            (
                ? [C2:foodchain] : 
                (
                    shorter_chain(C2, C) & 
                    chain_start(C2) = eater(L) & 
                    chain_end(C2) = chain_end(C) 
                )
            )
        )
    )
).

% Axiom7: There is no food chain from a species back to itself (no death spirals).
tff(no_self_foodchain, axiom, 
    ! [C:foodchain] : (
        chain_start(C) != chain_end(C) 
    )
).


% Axiom8: A complete food chain starts at a primary producer, and ends at an apex predator.
tff(complete_foodchain_decl, type, complete_foodchain: foodchain > $o).
tff(chain_is_complete, axiom, 
    ! [C:foodchain] : (
        complete_foodchain(C) => (
            primary_producer(chain_start(C)) &
            apex_predator(chain_end(C))
        )
    )
).
