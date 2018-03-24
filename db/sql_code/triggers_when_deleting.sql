use accumguojohns;

/*
Information about Triggers:

When a paper is deleted from the database: 
1. Its corresponding records in the citations table,
and keywords table  will also be deleted via
the CASCADE option for those foreign key constraints.
2. A trigger is called that will delete the corresponding journal from the database, unless
that journal references other papers that are still in the database.
3. A trigger is called that will delete paper-author tuples from the published table. This
will in turn call another trigger to delete an author from the authors table, only if that 
author has not published any other papers in the papers table.
4. A trigger is called that will delete all tuples from referenced that reference
the deleted paper. This will in turn call another trigger that will delete any articles
that no longer reference papers. A third trigger will be called that deletes any article_authors
that no longer have any articles in the database. 
*/


/*
Before a paper is deleted, delete the relevant tuples from the referenced table
and the published table. */
drop trigger if exists deletePublishedAndReferencedBeforePaperDeletion;
delimiter //
create trigger deletePublishedAndReferencedBeforePaperDeletion
before delete on papers
for each row
begin
	-- delete tuples from published table
    delete from published where paper_id = old.paper_id;
    
    -- delete tuples from referenced table
    delete from referenced where paper_id = old.paper_id;
    
end//
delimiter ;


/*After a paper is deleted from the papers table, delete its corresponding journal
only if the journal has no other papers that reference it. */
drop trigger if exists deleteJournalAfterPaperDeletion;
delimiter //
create trigger deleteJournalAfterPaperDeletion
after delete on papers
for each row
begin
	declare journal_count int;
    
	-- delete journal if it has no other papers referencing it 
    select count(*) into journal_count from papers where journal_id = old.journal_id;
    
    if journal_count = 0 then
    delete from journals where journal_id = old.journal_id;
	end if ;
    
    
end//
delimiter ;


/*After a paper-author tuple is deleted from the published table, delete
the corresponding author from the authors table only if that author has not
published any other papers in the database. */
drop trigger if exists deleteAuthorAfterDeletionFromPaperAuthors;
delimiter //
create trigger deleteAuthorAfterDeletionFromPaperAuthors
after delete on published
for each row
begin
	declare author_count int;

	-- delete author if it has no other papers referencing it 
    select count(*) into author_count from published where author_id = old.author_id;
    
    if author_count = 0 then
    delete from authors where author_id = old.author_id;
	end if ;

end//
delimiter ;
/*After an article-paper tuple has been deleted from referenced, delete the 
corresponding article only if it does not cite any other papers in the database. */
drop trigger if exists deleteArticlesAfterDeletionFromArticlesAboutPapers;
delimiter //
create trigger deleteArticlesAfterDeletionFromArticlesAboutPapers
after delete on referenced
for each row
begin
	declare article_count int;

	-- delete article if it has no other papers referencing it 
    select count(*) into article_count from referenced where article_id = old.article_id;
    
    if article_count = 0 then
    delete from articles where article_id = old.article_id;
	end if ;

end//
delimiter ;

/*After an article has been deleted, delete its author from the article_authors table
only if that author has not written any other articles in the database */
drop trigger if exists deleteArticleAuthorsAfterDeletionFromArticles;
delimiter //
create trigger deleteArticleAuthorsAfterDeletionFromArticles
after delete on articles
for each row
begin
	declare article_count int;

	-- delete author if they haven't written any other articles
    select count(*) into article_count from articles where author_id = old.author_id;
    
    if article_count = 0 then
    delete from article_authors where author_id = old.author_id;
	end if ;

end//
delimiter ;

