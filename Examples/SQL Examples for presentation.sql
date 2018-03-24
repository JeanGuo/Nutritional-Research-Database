use accumguojohns;

-- talk about schema
-- foreign key restrictions and triggers

-- reload schema
-- run all scripts

#############################################################
-- Example for reading (Jenny)
-- log in to user account
-- query for paper by title like 'pumpkin'
select * from papers where paper_title like '%pumpkin%';
call getPaperByTitle('pumpkin');
-- query by article with title like fish
select * from papers where paper_title like '%fish%';
-- enter article id to get papers cited by article 888
select * from papers where paper_id in (select paper_id from referenced where article_id =888);

#############################################################
-- Example of User suggesting a paper be deleted (Dujia)
-- user requests to delete paper 227 because it was redacted
-- intially empty
select * from delete_requests;
-- tuple appears after user request
select * from delete_requests;

-- log in as admin and show delete requests

#############################################################
-- Example for deleting a paper (Jenny)
-- Log in as admin

-- show in workbench that paper 127 exists and it has an entry in published
select * from papers where paper_id = 127;
select * from published where paper_id = 127;

-- paper author has only published one paper so the author should also be deleted
select * from published where author_id = 456; 
select * from authors where author_id = 456;

-- journal should be deleted because it only references one paper
select * from papers where journal_id = 16; 
select * from journals where journal_id = 16;

-- article should be deleted because it only references the one paper
select * from referenced where paper_id = 127; 
select * from referenced where article_id = 264;
select * from articles where article_id = 264;

-- Author has written more than one article so they should not be deleted from article_authors table
select * from articles where author_id = 289; 
select * from article_authors where author_id = 289;

-- admin on front end deletes paper 127

#############################################################
-- Example of adding a citation (Dujia)
-- Admin adds citation from front end

-- show current citations for paper id 3
select * from citations where paper_id = 3;
-- these papers cite each other currently
select * from papers where paper_id = 3;
select * from papers where paper_id = 758;

-- admin adds citation of paper 3 to paper 525
select * from papers where paper_id = 525;
-- show new citations
select * from citations where paper_id = 3;

#########################################################
-- Example of adding a keyword (Jenny)
-- user requests a keyword be added
select * from keyword_requests;

-- Admin adds a keyword
select * from keywords where keyword = 'guava';

select * from papers where paper_id = 15;

-- initially has no keywords attached to paper
select * from keywords where paper_id = 15;

-- admin adds keyword 'guava' to paper 15
select * from keywords where keyword = 'guava';