use accumguojohns;

-- search paper by author
drop procedure if exists search_paper_by_author;
delimiter //
create procedure search_paper_by_author
(
	aname varchar(45)
)
begin
	select * from paper
    where paper_id = any (select paper_id from 
							author a join paperauthors p on a.author_id = p.author_id
                            where a.author_lname like concat('%', aname, '%') or a.author_fname like concat('%', aname, '%') 
								or concat(a.author_fname, ' ', a.author_lname) like concat('%', aname, '%'));
end//
delimiter ;

-- search paper by title
drop procedure if exists search_paper_by_title;
delimiter //
create procedure search_paper_by_title
(
	paper_name varchar(45)
)
begin
	select * from paper 
    where paper_title like concat('%', paper_name, '%');
end//
delimiter ;

-- search paper by keyword
drop procedure if exists search_paper_by_keyword;
delimiter //
create procedure search_paper_by_keyword
(
	keyword_param varchar(140)
) 
begin
	select * from paper
    where paper_id = any (select paper_id 
							from keywords_in_papers
                            where keyword like concat('%', keyword_param, '%'));
end//
delimiter ;

-- search paper by journal and date
drop procedure if exists search_paper_by_journal_and_date;
delimiter //
create procedure search_paper_by_journal_and_date
(
	journal_param varchar(45),
    month_param char(3),
    year_param year(4)
)
begin
	select p.paper_id, p.paper_title, p.month_of_publication, p.year_of_publication, p.abstract, p.pages, j.journal_name
		from paper p join journal j on p.journal_id = j.journal_id
        where j.journal_name like concat('%', journal_param, '%')
				and p.year_of_publication = year_param 
                and p.month_of_publication = month_param;
end//
delimiter ;

-- search papers that are cited by a given paper
drop procedure if exists search_citations_of_paper;
delimiter //
create procedure search_citations_of_paper 
(
	paper_name_param varchar(45)
)
begin
	select * from paper
		where paper_id = any (select c.cited_paper_id
								from paper p join citations c on p.paper_id = c.paper_id
                                where p.paper_title like concat('%', paper_name_param, '%'));

end//
delimiter ;

-- search papers that cites given paper
drop procedure if exists search_paper_citing_given_paper;
delimiter //
create procedure search_paper_citing_given_paper
(
	paper_name_param varchar(45)
)
begin
	select * from paper 
		where paper_id = any (select paper_id from citations
								where cited_paper_id = any (select cited_paper_id
																from citations c join paper p on p.paper_id = c.cited_paper_id
																where p.paper_title like concat('%', paper_name_param, '%')));
                                
end//
delimiter ;
								
-- search for articles by title
drop procedure if exists search_article_by_title;
delimiter //
create procedure search_article_by_title
(
	article_title_param varchar(45)
)
begin
	select * from articles
    where article_name like concat('%', article_title_param, '%');
end//
delimiter ;

-- search articles by author
drop procedure if exists search_articles_by_author;
delimiter //
create procedure search_articles_by_author
(
	aname varchar(45)
)
begin
	select * from articles
    where article_id = any (select article_id 
								from article_authors aa join articles a on aa.author_id = a.author_id
                                where aa.author_fname like concat('%', aname, '%')
										or aa.author_lname like concat('%', aname, '%')
                                        or concat(aa.author_fname, ' ', aa.author_lname) like concat('%', aname, '%'));
end//
delimiter ;


-- search articles that cite paper that has a name of x 
	-- select articles that has citations with paper id that matches a paper name x

drop procedure if exists search_articles_by_cited_paper;

delimiter //

create procedure search_articles_by_cited_paper
(
	 paper_name1 varchar(45))

begin
	select * from articles where article_id = ANY (select a. article_id 
														from articles_about_papers ap join articles a on ap.article_id = a.article_id
														where paper_id = ANY (select p.paper_id 
																				from articles_about_papers ap join paper p on ap.paper_id = p.paper_id
																				where p.paper_title like concat('%', paper_name1, '%')));

end// 

delimiter ;

-- search authors of papers by author name

drop procedure if exists search_author_by_name;

delimiter //

create procedure search_author_by_name 
(
	author_name1 varchar(90)
)
begin 

	select * from author
		where author_fname like concat('%', author_name1, '%')
			or author_lname like concat('%', author_name1, '%')
			or concat(author_fname, ' ', author_lname) like concat('%', author_name1, '%');

end//

delimiter ;

-- search author by name of a paper

delimiter //

create procedure search_author_by_name_of_paper
(
	paper_title1 varchar(45)
)
begin 
	select a.author_id, a.author_fname, a.author_lname, a.author_degree, a.author_institution, a.author_contact
		from author a join paperauthors pa on a.author_id = pa.author_id
		where paper_id = ANY (select paper_id from paper
								where paper_title like concat('%', paper_title1, '%'));

end//

delimiter ;

