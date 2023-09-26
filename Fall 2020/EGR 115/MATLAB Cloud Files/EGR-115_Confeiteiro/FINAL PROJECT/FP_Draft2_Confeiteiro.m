% -----------------------------------------------------------------------
% Program Number: Final Project Draft #1
% Program Purpose: Hangman game with random word or user choice
%
% Created By: Krystian Confeiteiro
% Created On: 10/22/20
% Last Modified On: 11/08/20
%
% Credit To:
% By submitting this program with my name, I affirm that the creation and
% modifications of this program is primarily my own work.
%
% Comments:
% -----------------------------------------------------------------------

clc
clear
close all

%% welcome prompt and rules 
%welcome prompt
fprintf('\t\t\t\t\t\t\t\t-------------------\n\t\t\t\t\t\t\t\tWelcome to Hangman!\n\t\t\t\t\t\t\t\t-------------------\n');
fprintf('\nTo play, press any key!\n\n');
fprintf('You can have a quick game against the computer or against your friend!.');
fprintf('RULES: \n1.) Choose to play against the computer or a friend. If you are playing against a friend, enter a word to guess! \n2.) Guess a letter. If you are correct, keep guessing. ');
fprintf('If guess incorrectly, a part of the hangman will be added \n    until it is complete! If you guess the word or all the letters before your attempts run out, you win!.');
pause(2);  
fprintf('\n\nPress any key to continue...');
fprintf('\n----------------------------------------------------------------------------------------\n\n');
pause();
clc

%pause for a few seconds and clear screen to give classic game vibes
pause(1);
fprintf('Your game is loading...');
pause(3);
clc %clear screen to start the game

%% hangman character
%draw handman pole/noose (this will be printed first)
bBottom= line([0 10], [0 0],'color','k','lineWidth', 3); %bottom border
bLeft= line([0 0], [0 10],'color','k','lineWidth', 3); %left border
bTop= line([0 10], [10 10],'color','k','lineWidth', 3); %top border
bRight= line([10 10], [0 10],'color','k','lineWidth', 3); %right border

poleVertical = line([8 8],[8 0],'color', 'k','lineWidth', 3); %large vertical pole
poleHoriztonal = line([5.5 8],[8 8],'color','k','lineWidth', 3); %horizontal pole
poleVerticalSmall = line([5.5 5.5],[6 8],'color','b','lineWidth', 3); %small vertical pole
hold on

%**I will put these in the correct places once I have finished coding the rest** 

%draw head
theta = linspace(-2*pi,2*pi,50);                
headX = 5.5+0.5*cos(theta);
headY = 5.5+0.5*sin(theta);
plot(headX, headY,'color','k','lineWidth',3); %head

%draw body
line([5.5 5.5],[5 3],'color','k','lineWidth', 3); %body

%draw legs
line([5 5.5],[2 3],'color','k','lineWidth',3); %left leg
line([5.5 6],[3 2],'color','k','lineWidth',3); %right leg

%draw arms
line([5 5.5],[3.5 4.4],'color','k','lineWidth', 3); %left arm
line([5.5 6], [4.4 3.5],'color','k','lineWidth', 3); %right arm


%% input to play against the computer or another person, validate
%random list of words and choose random word
[~,~,hangmanWords] = xlsread('HangmanWords.xlsx');
randWord = hangmanWords{randi(10),randi(4)}; %<SM:RANDGEN> %<SM:RANDUSE> 

%ask if they want to use random guess or input their own word (+validation)
playerType = input('Do you want a randomly generated word or use your own word of choice?\nEnter ''computer'' for a computer generated word or ''player'' for your own word: ','s');
while (~strcmpi(playerType, 'computer') && ~strcmpi(playerType, 'player')) %<SM:BOP> %<SM:WHILE>
    playerType = input('ERROR, Enter ''computer'' for a computer generated word or ''player'' to enter your word of choice: ','s');
end
clc

%play vs computer or use a word of choice
if strcmpi(playerType, 'computer') %<SM:IF> %<SM:STRING> %rand computer word
    for j=1:length(randWord)  %<SM:FOR> %converts words to dashes
        correctLetters(j)= '-'; %<SM:AUG>
    end
elseif strcmpi(playerType, 'player') %user's word of choice
    userWord = input('\n\nEnter your word of choice: ','s');
    userWordLength = length(userWord); %find length of word for underscores
    while isempty(userWord) || isnumeric(userWord) %<SM:NEST> %validation 
        userWord = input('Error, please enter a word to start the game!: ','s');
        userWordLower = lower(userWord);
    end
    
    %replace the letters of the word with dashes for guessing
    for m = 1:userWordLength
        correctLetters(m) = '-';        
    end 
end 

%% print dashes to begin guessing
fprintf('%s\t',correctLetters);
fprintf('\n\n');
   
%% prompt for guesss, validate and crosscheck with word
%prompt for guess, validate, crosscheck with word
guessU = input('\nMake a guess: ','s'); %prompt guesses & validate
while isempty(guessU) || length(guessU)>1 || isnmumeric(guessU) 
    guessU = input('Error, guess a letter: ','s');
end
    
%determine if the guess matches one of the letters of the word
wrongLetters = [];
if strcmpi(playerType, 'computer') %wants to play against computer 
    for k = length(randWord) %loop for # of letters in the word
        guess1 = input('Guess a letter!: ');
        while isempty(guess) || isnumerical(guess) %validate the user's guesses
            guess = input('Error, please guess a letter!: ');
        end
        
        if strcmpi(guess, randWord) %a letter matches <SM:SEARCH>
            findLetters = find(strncmpi(guess, randWord, length(randWord))); %finds where the letters match
            correctLetters(k) = correctLetters(end+guess); %stores correct guess in the vector
        else %a letter does not match
            wrongLetters = sort(wrongLetters(end+guess)); %<SM:SORT> %sorts the wrong letters in alphabetical order
        end
    end
else %wants to play against another player
    for k = length(randWord) %loop for # of letters in the word
        %input for guess and validate
        guess2 = input('Guess a letter!: ');
        while isempty(guess2) || isnumerical(guess2) %validate the user's guesses
            guess = input('Error, please guess a letter!: ');
        end
        
        %if guess is right or wrong
        if strcnmpi(guess, randWord, length(randWord)) %a letter matches
            findLetters = find(strncmpi(guess, randWord, length(randWord))); %finds where the letters match
            correctLetters(k) = correctLetters(end+guess); %stores correct guess in the vector
            fprintf('There were %d occurences in the word, you have %d guesses left!', count(find(strcmpi(guess2, userWord))), k);
            pause(2); 
            fprintf('Press any key to continue onto your next guess!');
        else %a letter does not match
            wrongLetters = sort(wrongLetters(end+guess));  
        end
    end
end

