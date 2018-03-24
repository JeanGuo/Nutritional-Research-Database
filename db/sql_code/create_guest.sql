
use accumguojohns;

drop user if exists 'guest'@'localhost';
CREATE USER 'guest'@'localhost' IDENTIFIED BY 'guest_user';
GRANT select on accumguojohns.* to 'guest'@'localhost';
-- GRANT execute on accumguojohns.* to 'guest'@'localhost';

GRANT execute on procedure accumguojohns.getPaperByAuthor to 'guest'@'localhost';
GRANT execute on procedure accumguojohns.getPaperByTitle to 'guest'@'localhost';
GRANT execute on procedure accumguojohns.getPaperByKeyword to 'guest'@'localhost';
GRANT execute on procedure accumguojohns.getPaperByJournal to 'guest'@'localhost';
GRANT execute on procedure accumguojohns.getPaperByKeyword to 'guest'@'localhost';
GRANT execute on procedure accumguojohns.getPapersCitedByThisOne to 'guest'@'localhost';
GRANT execute on procedure accumguojohns.getPapersThatCiteThisOne to 'guest'@'localhost';
GRANT execute on procedure accumguojohns.getArticleByTitle to 'guest'@'localhost';
GRANT execute on procedure accumguojohns.getArticleByAuthor to 'guest'@'localhost';
GRANT execute on procedure accumguojohns.getArticleByPaperCitation to 'guest'@'localhost';
GRANT execute on procedure accumguojohns.getAuthorByName to 'guest'@'localhost';
GRANT execute on procedure accumguojohns.getPapersCitedByArticle to 'guest'@'localhost';

GRANT INSERT on accumguojohns.edit_requests
to 'guest'@'localhost';

GRANT INSERT on accumguojohns.article_requests
to 'guest'@'localhost';

GRANT INSERT on accumguojohns.paper_requests
to 'guest'@'localhost';

GRANT INSERT on accumguojohns.keyword_requests
to 'guest'@'localhost';


GRANT INSERT on accumguojohns.delete_requests
to 'guest'@'localhost';






