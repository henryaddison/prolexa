%%% Definite Clause Grammer for prolexa utterances %%%

utterance(C) --> sentence(C).
utterance(C) --> question(C).
utterance(C) --> command(C).

:- op(600, xfy, '=>').


%%% lexicon, driven by predicates %%%

adjective(_,M)		--> [Adj],    {pred2gr(_P,1,a/Adj, M)}.
noun(s,M)			--> [Noun],   {pred2gr(_P,1,n/Noun,M)}.
noun(p,M)			--> [Noun_p], {pred2gr(_P,1,n/Noun,M),noun_s2p(Noun,Noun_p)}.
iverb(s,M)			--> [Verb_s], {pred2gr(_P,1,v/Verb,M),verb_p2s(Verb,Verb_s)}.
iverb(p,M)			--> [Verb],   {pred2gr(_P,1,v/Verb,M)}.
prespart(_,M)			--> [PresPart],   {pred2gr(_P,1,pp/PresPart,M)}.
tverb(s, M) 		--> [Verb_s], {bpred2gr(_P,1,v/Verb,M),verb_p2s(Verb,Verb_s)}.
tverb(p, M) 		--> [Verb], {bpred2gr(_P,1,v/Verb,M)}.

% unary predicates for adjectives, nouns and verbs
pred(bird, 1,[n/bird]).
pred(wounded, 1,[a/wounded]).
pred(fly,     1,[v/fly]).
pred(ostrich,     1,[n/ostrich]).
pred(abnormal,     1,[a/abnormal]).
pred(muggle,   1,[n/muggle]).
pred(vanish,     1,[v/vanish]).
pred(magic,  1,[a/magic,n/magic]).
pred(circuit,   1,[n/circuit]).
pred(bell,   1,[n/bell]).
pred(switch,   1,[n/switch]).
pred(radio,   1,[n/radio]).
pred(lightbulb,   1,[n/lightbulb]).
pred(play,   1,[pp/playing]).
pred(glow,   1,[pp/glowing]).
pred(ring,   1,[pp/ringing]).
pred(complete,   1,[a/complete]).
pred(on,   1,[a/on]).

% binary predicates for transitive verbs
bpred(have, 1, [v/have]).

pred2gr(P,1,C/W,X=>Lit):-
	pred(P,1,L),
	member(C/W,L),
	Lit=..[P,X].

bpred2gr(P,1,C/W,Y=>X=>Lit):-
	bpred(P,1,L),
	member(C/W,L),
	Lit=..[P,X,Y].

noun_s2p(Noun_s,Noun_p):-
	( Noun_s=woman -> Noun_p=women
	; Noun_s=man -> Noun_p=men
	; Noun_s=bird -> Noun_p=birds
	; Noun_s=ostrich -> Noun_p=ostriches
	; Noun_s=person -> Noun_p=people
	; Noun_s=switch -> Noun_p=switches
	; atom_concat(Noun_s,s,Noun_p)
	).

verb_p2s(Verb_p,Verb_s):-
	( Verb_p=vanish -> Verb_s=vanishes
	; Verb_p=have -> Verb_s=has
	; 	atom_concat(Verb_p,s,Verb_s)
	).

%%% lexicon, proper nouns %%%

proper_noun(s,harry_potter) --> [harry].
proper_noun(s,harry_potter) --> [harry, potter].
proper_noun(s,mr_dursley) --> [mr, dursley].

proper_noun(s,colin) --> [colin].
proper_noun(s,dave) --> [dave].
proper_noun(s,bill) --> [bill].
proper_noun(s,arthur) --> [arthur].

%%% sentences %%%

sentence(C) --> sword,sentence1(C).
sentence(C) --> sword,sentence2(C).

sword --> [].
sword --> [that].

% most of this follows Simply Logical, Chapter 7
sentence1(C) --> determiner(N,M1,M2,C),noun(N,M1),verb_phrase(N,M2).
sentence1([(L:-true)]) --> proper_noun(N,X),verb_phrase(N,X=>L).
sentence1([not(L):-true]) -->  proper_noun(N,X),negated_verb_phrase(N,X=>L).
sentence1([(L:-true)]) --> article(N), noun(N,X=>Lit), verb_phrase(N,P=>L), {Lit=..[P, X]}.
sentence1(C) --> conditional(C).
sentence1(C) --> conditional2(C).
sentence1([(VM:-AM,NM)]) --> adjective(N, X=>AM), noun(N, X=>NM), verb_phrase(N, X=>VM).
sentence1([(M2:-M1)]) --> noun(p,X=>M1),verb_phrase(p,X=>M2).

sentence2([(L1:-true),(L2:-true)]) --> proper_noun(N,X),verb_phrases(N,X=>L1,X=>L2).
sentence2(C) --> sentence1(M1), [and], sentence1(M2), {append(M1, M2, C)}.

conditional([(H:-B)]) --> if_somebody, verb_phrase(s, X=>B), [then, they], verb_phrase(p, X=>H).
conditional([(H:-B)]) --> [if], sentence1([B:-true]), [then], sentence1([H:-true]).
conditional([(H:-not(B))]) --> if_somebody, negated_verb_phrase(s, X=>B), [then, they], verb_phrase(p, X=>H).

conditional2([(H:-B1,B2)]) --> if_somebody, verb_phrases(s, X=>B1, X=>B2), [then, they], verb_phrase(p, X=>H).
%conditional2([(H:-B1,B2)]) --> if_somebody, verb_phrases(s, X=>B1, X=>B2), [then, they], verb_phrase(p, X=>H).
conditional2([(H:-B1,B2)]) --> [if], sentence2([B1:-true, B2:-true]), [then], sentence1([H:-true]).

if_somebody --> [if, a, person].
if_somebody --> [if, someone].
if_somebody --> [if, somebody].

verb_phrase(s,M) --> [is],property(s,M).
verb_phrase(p,M) --> [are],property(p,M).
verb_phrase(N,M) --> iverb(N,M).
verb_phrase(N,M) --> modal_phrase(N,M).

verb_phrases(s,M1,M2) --> [is],two_property(s,M1,M2).

verb_phrase(N,M) --> negated_modal_phrase(N, M).
verb_phrase(s, M) --> [is], prespart(s, M).
verb_phrase(s, M) --> [are], prespart(p, M).
% transitive verb phrases
verb_phrase(N,X=>M) --> tverb(N, Y=>X=>M), article(ON), noun(ON, Y=>Lit), {Lit=..[P, Y], M=..[_, X, P]}.

negated_verb_phrase(s,M) --> [is,not],property(s,M).
negated_verb_phrase(p,M) --> [are,not],property(p,M).

modal_phrase(_N, X=>has_ability(X, P)) --> [can, do], noun(s, Y=>Lit), {Lit=..[P,Y]}.
modal_phrase(_N, X=>has_ability(X, P)) --> [can], iverb(p, Y=>Lit), {Lit=..[P,Y]}.

negated_modal_phrase(_N, X=>not(has_ability(X, P))) --> [cannot, do], noun(s, Y=>Lit), {Lit=..[P,Y]}.
negated_modal_phrase(_N, X=>not(has_ability(X, P))) --> [cannot], iverb(p, Y=>Lit), {Lit=..[P,Y]}.

article(s) --> [a].
article(p) --> [].
article(s) --> [the].
article(p) --> [the].

verb_phrases(s,M1,M2) --> [is],two_property(s,M1,M2).

property(N,M) --> adjective(N,M).
property(s,M) --> [a],noun(s,M).
property(s,M) --> [an],noun(s,M).
property(p,M) --> noun(p,M).
property(p,M) --> [a],noun(s,M).
property(p,M) --> [an],noun(s,M).
%property(p,M) --> negated_property(N, M).

two_property(s,M1,M2) --> property(s,M1),[and],property(s,M2).

%negated_property(N, Y=>not(P)) --> [not], property(N, Y=>Lit), {Lit=..[P,Y]}.


determiner(s,X=>B,X=>H,[(H:-B)]) --> [every].
determiner(p,X=>B,X=>H,[(H:-B)]) --> [all].
%determiner(p,X=>B,X=>H,[(H:-B)]) --> [].
%determiner(p, sk=>H1, sk=>H2, [(H1:-true),(H2 :- true)]) -->[some].

%%% questions %%%

question(Q) --> qword,question1(Q).

qword --> [].
%qword --> [if].
%qword --> [whether].

question1(Q) --> [who],verb_phrase(s,_X=>Q).
question1(Q) --> [is], proper_noun(N,X),property(N,X=>Q).
question1(Q) --> [does],proper_noun(_,X),verb_phrase(_,X=>Q).
question1(has_ability(X, P)) --> [can],proper_noun(_,X),[do], noun(s, Y=>Lit), {Lit=..[P,Y]}.
question1(has_ability(X, P)) --> [can],proper_noun(_,X), iverb(p, Y=>Lit), {Lit=..[P,Y]}.
%question1((Q1,Q2)) --> [are,some],noun(p,sk=>Q1),
%					  property(p,sk=>Q2).


%%% commands %%%

% These DCG rules have the form command(g(Goal,Answer)) --> <sentence>
% The idea is that if :-phrase(command(g(Goal,Answer)),UtteranceList). succeeds,
% it will instantiate Goal; if :-call(Goal). succeeds, it will instantiate Answer.
% See case C. in prolexa.pl
% Example:
%	command(g(random_fact(Fact),Fact)) --> [tell,me,anything].
% means that "tell me anything" will trigger the goal random_fact(Fact),
% which will generate a random fact as output for prolexa.

command(g(retractall(prolexa:stored_rule(_,C)),"I erased it from my memory")) --> forget,sentence(C).
command(g(retractall(prolexa:stored_rule(_,_)),"I am a blank slate")) --> forgetall.
command(g(all_rules(Answer),Answer)) --> kbdump.
command(g(all_answers(PN,Answer),Answer)) --> tellmeabout,proper_noun(s,PN).
command(g(explain_question(Q,_,Answer),Answer)) --> [explain,why],sentence1([(Q:-true)]).
command(g(random_fact(Fact),Fact)) --> getanewfact.
%command(g(pf(A),A)) --> peterflach.
%command(g(iai(A),A)) --> what.
command(g(rr(A),A)) --> thanks.

% The special form
%	command(g(true,<response>)) --> <sentence>.
% maps specific input sentences to specific responses.

command(g(true,"I can do a little bit of logical reasoning. You can talk with me about Harry Potter and Muggles.")) --> [what,can,you,do,for,me,minerva].
%command(g(true,"Your middle name is Adriaan")) --> [what,is,my,middle,name].
%command(g(true,"Today you can find out about postgraduate study at the University of Bristol. This presentation is about the Centre for Doctoral Training in Interactive Artificial Intelligence")) --> today.
%command(g(true,"The presenter is the Centre Director, Professor Peter Flach")) --> todaysspeaker.

thanks --> [thank,you].
thanks --> [thanks].
thanks --> [great,thanks].

getanewfact --> getanewfact1.
getanewfact --> [tell,me],getanewfact1.

getanewfact1 --> [anything].
getanewfact1 --> [a,random,fact].
getanewfact1 --> [something,i,'don\'t',know].

kbdump --> [spill,the,beans].
kbdump --> [tell,me],allyouknow.

forget --> [forget].

forgetall --> [forget],allyouknow.

allyouknow --> all.
allyouknow --> all,[you,know].

all --> [all].
all --> [everything].

tellmeabout --> [tell,me,about].
tellmeabout --> [tell,me],all,[about].

rr(A):-random_member(A,["no worries","the pleasure is entirely mine","any time, peter","happy to be of help"]).

random_fact(X):-
	random_member(X,["walruses can weigh up to 1900 kilograms", "There are two species of walrus - Pacific and Atlantic", "Walruses eat molluscs", "Walruses live in herds","Walruses have two large tusks"]).


%%% various stuff for specfic events

% today --> [what,today,is,about].
% today --> [what,is,today,about].
% today --> [what,is,happening,today].
%
% todaysspeaker --> [who,gives,'today\'s',seminar].
% todaysspeaker --> [who,gives,it].
% todaysspeaker --> [who,is,the,speaker].
%
% peterflach --> [who,is],hepf.
% peterflach --> [tell,me,more,about],hepf.
%
% what --> [what,is],iai.
% what --> [tell,me,more,about],iai.
%
% hepf --> [he].
% hepf --> [peter,flach].
%
% iai --> [that].
% iai --> [interactive,'A.I.'].
% iai --> [interactive,artificial,intelligence].
%
% pf("According to Wikipedia, Pieter Adriaan Flach is a Dutch computer scientist and a Professor of Artificial Intelligence in the Department of Computer Science at the University of Bristol.").
%
% iai("The Centre for Doctoral Training in Interactive Artificial Intelligence will train the next generation of innovators in human-in-the-loop AI systems, enabling them to responsibly solve societally important problems. You can ask Peter for more information.").
%
