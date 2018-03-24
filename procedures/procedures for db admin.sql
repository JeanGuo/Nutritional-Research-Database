use accumguojohns;

-- adding an article, where the author is already in the article_authors table
drop procedure if exists add_article_with_known_author;

delimiter //
create procedure add_article_with_known_author
(
	article_name_param varchar(45),
    article_publication_name_param varchar(45),
    article_publication_date_param date,
    article_author_param int(11),
    paper_id_param int(11)
)
begin
	declare article_id_param int(11);
    
	declare sql_error int default false;
    
    declare continue handler for sqlexception
		set sql_error = true;
	
    start transaction;
    
    select max(article_id) + 1
		into article_id_param
        from articles;
        
	insert into articles (article_id, article_name, publication_name, publication_date, author_id) values 
		(article_id_param, article_name_param, article_publication_name_param, article_publication_date_param, article_author_param);
        
    insert into referenced (article_id, paper_id) values
		(article_id_param, paper_id_param);
	
    if sql_error = false then
		commit;
        select 'Transaction was committed';
	else
		rollback;
        select 'Transaction was rolled back';
	end if;
    
end//
delimiter ;

-- add an article where the author is not yet in the article_authors table
drop procedure if exists add_article_with_new_author;

delimiter //
create procedure add_article_with_new_author
(
	article_name_param varchar(45),
    article_pub_name_param varchar(45),
    article_pub_date_param date,
    author_fname_param varchar(45),
    author_lname_param varchar(45),
    paper_id_param int(11)
)
begin
	declare author_id_param int(11);
    declare article_id_param int(11);
    
	declare sql_error int default false;
    
    declare continue handler for sqlexception
		set sql_error = true;
	
    start transaction;
    
    select max(author_id) + 1
		into author_id_param
        from article_authors;
        
	select max(article_id) + 1
		into article_id_param
        from articles;
        
    insert into article_authors (author_id, author_fname, author_lname) values
		(author_id_param, author_fname_param, author_lname_param);
        
	insert into articles (article_id, article_name, publication_name, publication_date, author_id) values
		(article_id_param, article_name_param, article_pub_name_param, article_pub_date_param, author_id_param);
            
	insert into referenced (article_id, paper_id) values
		(article_id_param, paper_id_param);
	
    if sql_error = false then
		commit;
        select 'Transaction was committed.';
	else
		rollback;
        select 'Transaction was rolled back.';
	end if;
end//

delimiter ;

-- adding a paper, where the author_id is already known (author is already in author table)
drop procedure if exists add_paper_with_known_author_and_known_journal;

delimiter //
create procedure add_paper_with_known_author_and_known_journal
(
	paper_title_param varchar(45),
    month_param char(3),
    year_param year,
    abstract_param varchar(140),
    pages_param varchar(45),
    journal_param int(11),
    author_param int(11)
)
begin
	declare paper_id_param int(11);
    
	declare sql_error int default false;
    
    declare continue handler for sqlexception
		set sql_error = true;
        
	start transaction;
    
    select max(paper_id) + 1
		into paper_id_param
        from papers;
            
	insert into papers (paper_id, paper_title, month_of_publication, year_of_publication, abstract, pages, journal_id) values
		(paper_id_param, paper_title_param, month_param, year_param, abstract_param, pages_param, journal_param);
            
	insert into published (paper_id, author_id) values
		(paper_id_param, author_param);
        
	if sql_error = false then
		commit;
		select 'Transaction was committed';
	else 
		rollback;
        select 'Transaction was rolled back';
	end if;
end//
delimiter ;

-- add paper with author not yet in author table
drop procedure if exists add_paper_with_new_author_and_known_journal;

delimiter //
create procedure add_paper_with_new_author_and_known_journal
(
	author_fname_param varchar(45),
    author_lname_param varchar(45),
    author_degree_param varchar(45),
    author_institution_param varchar(45),
    author_contact_param varchar(45),
    paper_title_param varchar(45),
    paper_month_param char(3),
    paper_year_param year(4),
    paper_abstract_param varchar(140),
    paper_pages_param varchar(45),
    journal_param int(11)
)
begin
	declare paper_id_param int(11);
    declare author_id_param int(11);
    
	declare sql_error int default false;
    
    declare continue handler for sqlexception
		set sql_error = true;
        
    start transaction;
    
	select max(paper_id) + 1
		into paper_id_param
        from papers;
		
	select max(author_id) + 1
		into author_id_param
        from authors;
        
    insert into papers (paper_id, paper_title, month_of_publication, year_of_publication, abstract, pages, journal_id) values
		(paper_id_param, paper_title_param, paper_month_param, paper_year_param, paper_abstract_param, paper_pages_param, journal_param);
	
    insert into authors (author_id, author_fname, author_lname, author_degree, author_institution, author_contact) values
		(author_id_param, author_fname_param, author_lname_param, author_degree_param, author_institution_param, author_contact_param);
        
	insert into published (paper_id, author_id) values
		(paper_id_param, author_id_param);
        
	if sql_error = false then
		commit;
        select 'Transaction was committed';
	else
		rollback;
        select 'Transaction was rolled back';
	end if;
end//

delimiter ;

drop procedure if exists add_paper_with_new_author_and_new_journal;

delimiter //
create procedure add_paper_with_new_author_and_new_journal
(
	author_fname_param varchar(45),
    author_lname_param varchar(45),
    author_degree_param varchar(45),
    author_institution_param varchar(45),
    author_contact_param varchar(45),
    paper_title_param varchar(45),
    paper_month_param char(3),
    paper_year_param year(4),
    paper_abstract_param varchar(140),
    paper_pages_param varchar(45),
    journal_name_param varchar(45),
    journal_issue_number_param int(11),
    journal_year_param year(4)
)
begin
	declare paper_id_param int(11);
    declare author_id_param int(11);
    declare journal_id_param int(11);
    
	declare sql_error int default false;
    
    declare continue handler for sqlexception
		set sql_error = true;
        
    start transaction;
    
	select max(paper_id) + 1
		into paper_id_param
        from papers;
		
	select max(author_id) + 1
		into author_id_param
        from authors;
        
	select max(journal_id) + 1
		into journal_id_param
        from journals;
        
	insert into journals (journal_id, journal_name, issue_number, journal_year) values
		(journal_id_param, journal_name_param, journal_issue_number_param, journal_year_param);
        
    insert into papers (paper_id, paper_title, month_of_publication, year_of_publication, abstract, pages, journal_id) values
		(paper_id_param, paper_title_param, paper_month_param, paper_year_param, paper_abstract_param, paper_pages_param, journal_id_param);
	
    insert into authors (author_id, author_fname, author_lname, author_degree, author_institution, author_contact) values
		(author_id_param, author_fname_param, author_lname_param, author_degree_param, author_institution_param, author_contact_param);
        
	insert into published (paper_id, author_id) values
		(paper_id_param, author_id_param);
        
	if sql_error = false then
		commit;
        select 'Transaction was committed';
	else
		rollback;
        select 'Transaction was rolled back';
	end if;
end//

delimiter ;

drop procedure if exists add_paper_with_known_author_and_new_journal;

delimiter //
create procedure add_paper_with_known_author_and_new_journal
(
	paper_title_param varchar(45),
    month_param char(3),
    year_param year,
    abstract_param varchar(140),
    pages_param varchar(45),
    author_param int(11),
    journal_name_param varchar(45),
    journal_issue_number_param int(11),
    journal_year_param year(4)
)
begin
	declare paper_id_param int(11);
	declare journal_id_param int(11);

	declare sql_error int default false;
    
    declare continue handler for sqlexception
		set sql_error = true;
        
	start transaction;
    
    select max(paper_id) + 1
		into paper_id_param
        from papers;
	
    select max(journal_id) + 1
		into journal_id_param
        from journals;
	
    insert into journals (journal_id, journal_name, issue_number, journal_year) values
		(journal_id_param, journal_name_param, journal_issue_number_param, journal_year_param);
        
	insert into papers (paper_id, paper_title, month_of_publication, year_of_publication, abstract, pages, journal_id) values
		(paper_id_param, paper_title_param, month_param, year_param, abstract_param, pages_param, journal_id_param);
            
	insert into published (paper_id, author_id) values
		(paper_id_param, author_param);
        
	if sql_error = false then
		commit;
		select 'Transaction was committed';
	else 
		rollback;
        select 'Transaction was rolled back';
	end if;
end//

delimiter ;

-- delete paper
drop procedure if exists delete_paper;

delimiter //
create procedure delete_paper
(
	paper_id_param int(11)
)
begin
	delete from papers where paper_id = paper_id_param;
end//
delimiter ;

-- add a keyword
drop procedure if exists add_keyword;

delimiter //
create procedure add_keyword
(
	paper_id_param int(11),
    keyword_param varchar(140)
)
begin
	insert into keywords values
		(paper_id_param, keyword_param);
end//
delimiter ;

-- add citation
drop procedure if exists add_citation;

delimiter //
create procedure add_citation
(
	paper_id_param int(11),
    cited_paper_id_param int(11)
)
begin
	insert into citations values
		(paper_id_param, cited_paper_id_param);
end//

delimiter ;