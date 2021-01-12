# Henry and Vanessa's submission #

### Examples we addressed

1. [Harry Potter (imaginary worlds)](https://rule-reasoning.apps.allenai.org/?p=Harry%20can%20do%20magic.%20%0AMuggles%20cannot%20do%20magic.%20%0AIf%20a%20person%20can%20do%20magic%20then%20they%20can%20vanish.%20%0AMr%20Dursley%20is%20a%20Muggle.&q=Harry%20can%20vanish.%20%0AMr%20Dursley%20can%20vanish)
2. [Ostriches and wounded birds don't fly (Birds Rulebase)](https://rule-reasoning.apps.allenai.org/?p=Arthur%20is%20a%20bird.%20%0AArthur%20is%20not%20wounded.%20%0ABill%20is%20an%20ostrich.%20%0AColin%20is%20a%20bird.%20%0AColin%20is%20wounded.%20%0ADave%20is%20not%20an%20ostrich.%20%0ADave%20is%20wounded.%20%0AIf%20someone%20is%20an%20ostrich%20then%20they%20are%20a%20bird.%20%0AIf%20someone%20is%20an%20ostrich%20then%20they%20are%20abnormal.%20%0AIf%20someone%20is%20an%20ostrich%20then%20they%20cannot%20fly.%20%0AIf%20someone%20is%20a%20bird%20and%20wounded%20then%20they%20are%20abnormal.%20%0AIf%20someone%20is%20wounded%20then%20they%20cannot%20fly.%20%0AIf%20someone%20is%20a%20bird%20and%20not%20abnormal%20then%20they%20can%20fly.&q=Arthur%20can%20fly.%20%0ABill%20can%20fly.%20%0AColin%20can%20fly.%20%0ADave%20can%20fly.)
3. [Birds typically don't fly, but ostriches can (Birds Rulebase)](https://rule-reasoning.apps.allenai.org/?p=If%20someone%20is%20an%20ostrich%20then%20they%20can%20fly.%20%0AIf%20someone%20is%20an%20ostrich%20then%20they%20are%20a%20bird.%20%0AIf%20someone%20is%20a%20bird%20and%20not%20abnormal%20then%20they%20cannot%20fly.%20%0AIf%20someone%20can%20fly%20then%20they%20are%20abnormal.%20%0AArthur%20is%20a%20bird.%20%0ABill%20is%20an%20ostrich.&q=Arthur%20can%20fly.%20%0ABill%20can%20fly)
4. [Electricity Rulebase 1](https://rule-reasoning.apps.allenai.org/?p=The%20circuit%20has%20a%20switch.%20%0AThe%20circuit%20has%20a%20bell.%20%0AThe%20switch%20is%20on.%20%0AIf%20the%20circuit%20has%20the%20switch%20and%20the%20switch%20is%20on%20then%20the%20circuit%20is%20complete.%20%0AIf%20the%20circuit%20does%20not%20have%20the%20switch%20then%20the%20circuit%20is%20complete.%20%0AIf%20the%20circuit%20is%20complete%20and%20the%20circuit%20has%20the%20light%20bulb%20then%20the%20light%20bulb%20is%20glowing.%20%0AIf%20the%20circuit%20is%20complete%20and%20the%20circuit%20has%20the%20bell%20then%20the%20bell%20is%20ringing.%20%0AIf%20the%20circuit%20is%20complete%20and%20the%20circuit%20has%20the%20radio%20then%20the%20radio%20is%20playing.&q=The%20bell%20is%20ringing.%20%0AThe%20light%20bulb%20is%20glowing.%20%0AThe%20radio%20is%20playing)


### Loading an example

Ask prolexa to "load example xyz" and the memory will be wiped and the facts and rules as given by the example are loaded.

```
prolexa> “load example harry_potter".
prolexa> “load example bird_1".
prolexa> “load example bird_2".
prolexa> “load example electricity".

```

The riddle's "Is it true?" questions can be tested by either asking a direct question:
```
prolexa> "Is the bell is ringing".
```
or by asking prolexa to explain:
```
prolexa> "Explain why Bill cannot fly".
```

### Interesting things to try


#### 1. Proving something is not

In some of our cases, negation works as failure.

```
prolexa> “Muggles cannot do magic”.
prolexa> “If someone can do magic then they can vanish”.
prolexa> “Mr Dursley is a Muggle”.
prolexa> “Can Mr Dursley vanish”.
```

Other times we had to implement a rule to check if the information had been explicitly declared or inferred. For example in this case, it needs to be implied that when something has not been declared as abnormal, that it is then normal. This example needs to handle both negations and conjunctions. 

```
prolexa> "If someone is an ostrich then they are abnormal".
prolexa> “If someone is a bird and not abnormal then they can fly”.
prolexa> “Explain why Arthur can fly”.
```

#### 2. Rules and facts with conjunction

Sentences and properties can be conjoined using “and” meaning that an utterance may include more than one fact and the head or body of a rule may have multiple parts.

The following will determine that Colin is wounded and a bird from a single utterance
```
prolexa> “Colin is a bird and wounded”.
prolexa> “Is Colin wounded”.
prolexa> “Is Colin a bird”.
```

The following shows an example of a conditional sentence making a rule with a conjunctive body:
```
prolexa> “If the circuit has the switch and the switch is on then the circuit is complete”.
prolexa> “The circuit has the switch”.
prolexa> “The switch is on”.
prolexa> “Is the circuit complete”.
```

#### 3. Transitive verbs

Transitive verbs require a subject and an object so need binary rather than unary predicates. For example:
```
prolexa> “The circuit has a switch”.
```
adds the rule `has(circuit, switch):-true` to the rulebase

#### 4. Nouns as constants rather than properties

Common nouns can be handled in two ways. The circuit example required nouns to be regarded as constants in some cases as opposed to properties of proper nouns such as in the bird example.

```
prolexa> “bill is an ostrich”.
prolexa> “the bell is ringing”.
prolexa> “if someone is an ostrich then they are abnormal”.
```
adds the rules `(ostrich(bill):-true),(ringing(bell):-true),(abnormal(X):-ostrich(X))` to the rulebase



---
---


### Read me from original code


This repository contains Prolog code for a simple question-answering assistant. The top-level module is `prolexa.pl`, which can either be run in the command line or with speech input and output through the
[alexa developer console](https://developer.amazon.com/alexa/console/ask).

The heavy lifting is done in
`prolexa_grammar.pl`, which defines DCG rules for
sentences (that are added to the knowledge base if they don't already follow),
questions (that are answered if possible), and
commands (e.g., explain why something follows); and
`prolexa_engine.pl`, which implements reasoning by means of meta-interpreters.

Also included are `nl_shell.pl`, which is taken verbatim from Chapter 7 of *Simply Logical*,
and an extended version `nl_shell2.pl`, which formed the basis for the `prolexa` code.

The code has been tested with [SWI Prolog](https://www.swi-prolog.org) versions 7.6.0 and 8.0.3.

# Command-line interface #

```
% swipl prolexa.pl
Welcome to SWI-Prolog (threaded, 64 bits, version 8.0.3)
SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software.
Please run ?- license. for legal details.

For online help and background, visit http://www.swi-prolog.org
For built-in help, use ?- help(Topic). or ?- apropos(Word).

?- prolexa_cli.
prolexa> "Tell me everything you know".
*** utterance(Tell me everything you know)
*** goal(all_rules(_7210))
*** answer(every human is mortal. peter is human)
every human is mortal. peter is human
prolexa> "Peter is mortal".
*** utterance(Peter is mortal)
*** rule([(mortal(peter):-true)])
*** answer(I already knew that Peter is mortal)
I already knew that Peter is mortal
prolexa> "Explain why Peter is mortal".
*** utterance(Explain why Peter is mortal)
*** goal(explain_question(mortal(peter),_8846,_8834))
*** answer(peter is human; every human is mortal; therefore peter is mortal)
peter is human; every human is mortal; therefore peter is mortal
```


# Amazon Alexa and Prolog integration #

Follow the steps below if you want to use the Amazon Alexa speech to text and text to speech facilities.
This requires an HTTP interface that is exposed to the web, for which we use
[Heroku](http://heroku.com).

## Generating intent json for Alexa ##
```
swipl -g "mk_prolexa_intents, halt." prolexa.pl
```
The intents are found in `prolexa_intents.json`. You can copy and paste the contents of this file while building your skill on the
[alexa developer console](https://developer.amazon.com/alexa/console/ask).


## Localhost workflow (Docker) ##
To build:
```
docker build . -t prolexa
```

To run:
```
docker run -it -p 4000:4000 prolexa
```

To test the server:
```
curl -v POST http://localhost:4000/prolexa -d @testjson --header "Content-Type: application/json"
```

## Heroku workflow ##
### Initial setup ###
Prerequisites:

- Docker app running in the background
- Installed Heroku CLI (`brew install heroku/brew/heroku`)

---

To see the status of your Heroku webapp use
```
heroku logs
```

in the prolexa directory.

---

1. Clone this repository
    ```
    git clone git@github.com:So-Cool/prolexa.git
    cd prolexa
    ```

2. Login to Heroku
    ```
    heroku login
    ```

3. Add Heroku remote
    ```
    heroku git:remote -a prolexa
    ```

### Development workflow ###
1. Before you start open your local copy of Prolexa and login to Heroku
    ```
    cd prolexa
    heroku container:login
    ```

2. Change local files to your liking
3. Once you're done push them to Heroku
    ```
    heroku container:push web
    heroku container:release web
    ```

4. Test your skill and repeat steps *2.* and *3.* if necessary
5. Once you're done commit all the changes and push them to GitHub
    ```
    git commit -am "My commit message"
    git push origin master
    ```
