#a script to work with text

#installing packages
library(tidyverse)
library(coreNLP)
library(rJava)

#loading the English model
initCoreNLP("../NLP_library/stanford_core_models", type = c("english_fast"), 
            parameterFile = NULL,
            mem = "3g")


#listing the functions in Core NLP
lsf.str("package:coreNLP")

#annotation object example
camus <- annoEtranger

#importing Arthur Gordon Pym of Nantucket text from Project Gutenberg
pym_full_raw <- read_delim("https://www.gutenberg.org/cache/epub/51060/pg51060.txt", delim = "\t")


#turning it into a character vector.
pym_full_flat <- str_flatten(deframe(pym_full_raw), collapse = " ") 

#strip out before the title
pym_full <- pym_full_flat %>% str_split_i(., "THE NARRATIVE OF ARTHUR GORDON PYM. OF NANTUCKET.",2) 

#strip out the ending after "THE END."
pym_full <- pym_full %>% str_split_i("THE END.",1)
str(pym_full)

#break up the full text into chapters.
str_count(pym_full, "CHAPTER") #24 chapters not including the preface
pym_chapters <- str_split_1(pym_full, "CHAPTER")
str(pym_chapters) #is a character vector of each chapter. 

#just a small excerpt
pym_excerpt <- "Augustus Barnard thoroughly entered into my state of mind. It is probable, indeed, that our intimate communion, Augustus and mine, had resulted in a partial interchange of character. About eighteen months after the period of the Ariel's disaster, the firm of Lloyd and Vredenburgh (a house connected in some manner with the Messieurs Enderby, I believe, of Liverpool) were engaged in repairing and fitting out the brig Grampus of Philadelphia for a whaling voyage."

#annotate 
pym_ex_annotated <- annotateString(pym_excerpt)

#core references show the sentence character starts /end etc.
getCoreference(pym_ex_annotated)

#shows the parsed values
getParse(pym_ex_annotated)

#gives dependency tags by location and governors.
pym_ex_depend <- getDependency(pym_ex_annotated)



#gives sentiment level data by sentence level!
getSentiment(pym_ex_annotated)

#getting tokens? 
str(getToken(pym_ex_annotated))
pym_tokens <- getToken(pym_ex_annotated)
pym_tokens %>%
  filter(NER != "O")

pym_characters <- pym_tokens %>% filter(NER == "PERSON")

#repeating for the whole text. 
pym_chapters[1]
pym_chap_anno <- annotateString(pym_chapters[1])

pym_characters <- getToken(pym_chap_anno) %>% 
                             filter(NER == "PERSON") %>%
                             unique()


