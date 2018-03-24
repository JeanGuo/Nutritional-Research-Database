-- procedures for use by guest user

use accumguojohns;

-- search paper by author
drop procedure if exists getPaperByAuthor;
delimiter //
create procedure getPaperByAuthor
(
	aname varchar(45)
)
begin
	select * from papers
    where paper_id = any (select paper_id from 
							authors a join published p on a.author_id = p.author_id
                            where a.author_lname like concat('%', aname, '%') or a.author_fname like concat('%', aname, '%') 
								or concat(a.author_fname, ' ', a.author_lname) like concat('%', aname, '%'));
end//
delimiter ;


-- search paper by title
drop procedure if exists getPaperByTitle;
delimiter //
create procedure getPaperByTitle
(
title varchar(45)
)
begin

select * from papers
where paper_title like concat('%',title,'%');

end//
delimiter ;


-- search paper by keyword
drop procedure if exists getPaperByKeyword;
delimiter //
create procedure getPaperByKeyword
(
	keyword_param varchar(140)
) 
begin
	select * from papers
    where paper_id = any (select paper_id 
							from keywords
                            where keyword like concat('%', keyword_param, '%'));
end//
delimiter ;

-- search paper by journal and date
drop procedure if exists getPaperByJournal;
delimiter //
create procedure getPaperByJournal
(
	journal_param varchar(45)
)
begin
	select p.paper_id, p.paper_title, p.month_of_publication, p.year_of_publication, p.abstract, p.pages, j.journal_name
		from papers p join journals j on p.journal_id = j.journal_id
        where j.journal_name like concat('%', journal_param, '%');
end//
delimiter ;


-- search papers that are cited by a given paper
drop procedure if exists getPapersCitedByThisOne;
delimiter //
create procedure getPapersCitedByThisOne 
(
	given_paper_id int(11)
)
begin
	select * from papers
		where paper_id = any (select cited_paper_id
								from citations 
                                where paper_id = given_paper_id);

end//
delimiter ;


-- search papers that cites given paper
drop procedure if exists getPapersThatCiteThisOne;
delimiter //
create procedure getPapersThatCiteThisOne
(
	given_paper_id int(11)
)
begin
	select * from papers 
		where paper_id = any (select paper_id from citations
								where cited_paper_id = given_paper_id);
                                
end//
delimiter ;

								
-- search for articles by title
drop procedure if exists getArticleByTitle;
delimiter //
create procedure getArticleByTitle
(
	article_title_param varchar(45)
)
begin
	select * from articles
    where article_name like concat('%', article_title_param, '%');
end//
delimiter ;

-- search articles by author
drop procedure if exists getArticleByAuthor;
delimiter //
create procedure getArticleByAuthor
(
	aname varchar(45)
)
begin
	select article_id, article_name, publication_name, publication_date, a.author_id, author_fname, author_lname 
    from articles a join article_authors au on a.author_id = au.author_id
    where article_id = any (select article_id 
								from article_authors aa join articles a on aa.author_id = a.author_id
                                where aa.author_fname like concat('%', aname, '%')
										or aa.author_lname like concat('%', aname, '%')
                                        or concat(aa.author_fname, ' ', aa.author_lname) like concat('%', aname, '%'));
end//
delimiter ;

-- search articles that cite paper that has a name of x 
	-- select articles that has citations with a given paper id
drop procedure if exists getArticleByPaperCitation;
delimiter //
create procedure getArticleByPaperCitation
(
	 given_paper_id int(11))

begin
                                
	select * from articles where article_id in (select article_id from referenced where 
    paper_id = given_paper_id);

end// 
delimiter ;


-- search authors of papers by author name
drop procedure if exists getAuthorByName;
delimiter //
create procedure getAuthorByName 
(
	author_name1 varchar(90)
)
begin 

	select * from authors
		where author_fname like concat('%', author_name1, '%')
			or author_lname like concat('%', author_name1, '%')
			or concat(author_fname, ' ', author_lname) like concat('%', author_name1, '%');

end//
delimiter ;


-- get papers cited by an article
drop procedure if exists getPapersCitedByArticle;

delimiter //
create procedure getPapersCitedByArticle
(
given_article int(11)
)
begin
select * from papers where paper_id in 
(select paper_id from referenced where article_id = given_article);

end//
delimiter ;

