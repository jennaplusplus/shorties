# shorties
generating a new episode of Arrested Development for the Algorithmia Shorties contest

@peap and I worked on an Arrested Development script generator!

The code lives at https://github.com/jennaplusplus/shorties/ and there's a generated episode with 300 lines at https://github.com/jennaplusplus/shorties/blob/master/episode_2.txt

Transcripts for the first three seasons of the show were obtained from http://arresteddevelopment.wikia.com/ with retrieve-transcripts.rb. Trigrams were generated for all characters with more than 10 lines overall, for a total of 71 trigram files (generate-trigrams.rb).

The episode script was generated with generate-episode.rb. The order of characters in the script was selected randomly, weighted by the size of the characters' trigram files. The order of the script was further modified to ensure that the Narrator always starts the episode and a character doesn't speak twice in a row. Each line is 1-5 sentences long.
