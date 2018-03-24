// Assignment
// Accum Meredith
// accum.m

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class Model {

  private boolean admin; // true if admin, false if guest
  private String dbURL = "jdbc:mysql://localhost:3306/accumguojohns";
  private Readable rd;
  private Scanner sc;

  public Model(boolean admin, String dbURL, Readable rd) {
    this.admin = admin;
    this.dbURL = dbURL;
    this.rd = rd;
    this.sc = new Scanner(rd);
    sc.useDelimiter("\n|\\n|\r\n|\\r\\n");
  }

  public void run(String username, String password) {
    if (admin) {
      runAdmin(username, password);
    } else {
      runGuest(username, password);
    }
  }

  private void runAdmin(String username, String password) {
    while (true) {
      System.out.println("\nEnter Q to enter an SQL statement, P to view pending approvals, "
              + "\nA to perform an admin function"
              + "\nor enter Z to quit:\n");
      String query = sc.next();

      if (query.equals("Z")) {
        System.out.println("Quit.");
        return;
      } else if (query.equals("Q")) {
        // run any SQL statement
        System.out.println("\nEnter SQL statement to run.");
        query = sc.next();
        runAdminStatement(username, password, query);
      } else if (query.equals("P")) {
        showPendingApprovals(username, password);
      } else if (query.equals("A")) {
        showAdminFunctions(username, password);
      }

    }
  }

  private void showPendingApprovals(String username, String password) {
    System.out.println("\nEnter E to show Edit requests, "
            + "\nA to show Article requests, "
            + "\nK to show Keyword requests, "
            + "\nP to show Paper requests, "
            + "\nor D to show Delete requests."
            + "\nZ to go back.");
    String input = sc.next();
    if (input.equals("Z")) {
      return;
    } else if (input.equals("E")) {
      runAdminStatement(username, password, "call showEditRequests()");
    } else if (input.equals("A")) {
      runAdminStatement(username, password, "call showArticleRequests()");
    } else if (input.equals("K")) {
      runAdminStatement(username, password, "call showKeywordRequests()");
    }else if (input.equals("P")) {
      runAdminStatement(username, password, "call showPaperRequests()");
    } else if (input.equals("D")) {
      runAdminStatement(username, password, "call showDeleteRequests()");
    }
    showAdminFunctions(username, password);
  }

  private void showAdminFunctions(String username, String password) {
    System.out.println("\nEnter Z to go back. "
            + "\nTo perform an admin function, enter one of the following:"
            + "\nEnter A to add an article."
            + "\nEnter P to add a paper."
            + "\nEnter D to delete a paper."
            + "\nEnter K to add a keyword."
            + "\nEnter C to add a Citation");
    String input = sc.next();
    if (input.equals("Z")) {
      return;
    } else if (input.equals("A")) {
      adminAddArticle(username, password);
    } else if (input.equals("P")) {
      adminAddPaper(username, password);
    } else if (input.equals("D")) {
      adminDeletePaper(username, password);
    }else if (input.equals("K")) {
      adminAddKeyword(username, password);
    } else if (input.equals("C")) {
      adminAddCitation(username, password);
    }
  }

  public void adminAddArticle(String username, String password) {

    System.out.println("\nEnter title of article:");
    String title = sc.next();
    System.out.println("Enter publication of article:");
    String publication = sc.next();
    System.out.println("Enter date of article:");
    String date = sc.next();
    System.out.println("Enter paper_id of the paper cited by the article:");
    String paper_id = sc.next();


    System.out.println("Is the author already in the database? Enter Y or N:");
    String bool = sc.next();
    if (bool.equals("Y")) {
      System.out.println("Enter ID of author of article:");
      String author_id = sc.next();
      runAdminStatement(username, password,
              "call add_article_with_known_author('"+title+"', '"+publication+"', '"+date+"', "
                      +author_id+", "+paper_id+")");
    } else {
      System.out.println("Enter the first name of the author:");
      String first = sc.next();
      System.out.println("Enter the last name of the author:");
      String last = sc.next();
      runAdminStatement(username, password,
              "call add_article_with_new_author('"+title+"', '"+publication+"', '"+date+"', '"
                      +first+"','"+last+"' , "+paper_id+")");
    }

  }

  public void adminAddPaper(String username, String password) {
    System.out.println("\nEnter title of paper:");
    String title = sc.next();
    System.out.println("Enter month of publication:");
    String month = sc.next();
    System.out.println("Enter year of publication:");
    String year = sc.next();
    System.out.println("Enter abstract of paper:");
    String abstr = sc.next();
    System.out.println("Enter pages of paper's location in journal, if known:");
    String pages = sc.next();


    String journal_id = null;
    String journal_name = null;
    String journal_issue_number = null;
    String journal_year = null;

    System.out.println("Is the journal already in the database? Enter Y or N:");
    String journal_boolean = sc.next();
    if (journal_boolean.equals("Y")) {
      System.out.println("Enter the journal id #:");
      journal_id = sc.next();
    } else {
      System.out.println("Enter the journal name:");
      journal_name = sc.next();
      System.out.println("Enter the journal issue number:");
      journal_issue_number = sc.next();
      System.out.println("Enter the journal year:");
      journal_year = sc.next();
    }

    String author_id = null;
    String fName = null;
    String lName = null;
    String degree = null;
    String institution = null;
    String contact = null;

    System.out.println("Is the author already in the database? Enter Y or N:");
    String author_boolean = sc.next();
    if (author_boolean.equals("Y")) {
      System.out.println("Enter the author id #:");
      author_id = sc.next();
    } else {
      System.out.println("Enter the author's first name:");
      fName = sc.next();
      System.out.println("Enter the author's last name:");
      lName = sc.next();
      System.out.println("Enter the author's degree:");
      degree = sc.next();
      System.out.println("Enter the author's institution:");
      institution = sc.next();
      System.out.println("Enter the author's contact information:");
      contact = sc.next();
    }

    if (journal_boolean.equals("Y") && author_boolean.equals("Y")) {
      // known author and journal
      runAdminStatement(username, password,
              "call add_paper_with_known_author_and_known_journal('"+title+"', '"+month+"', "+year+", "
                      + "'"+abstr+"', '"+pages+"', "+journal_id+", "+author_id+")");

    } else if (journal_boolean.equals("Y") && !author_boolean.equals("Y")) {
      // known journal, unknown author
      runAdminStatement(username, password,
              "call add_paper_with_new_author_and_known_journal('"+fName+"', '"+lName+"', "
                      + "'"+degree+"', '"+institution+"', '"+contact+"',"
                      + "'"+title+"', '"+month+"', "+year+", "
                      + "'"+abstr+"', '"+pages+"', "+journal_id+")");

    } else if (!journal_boolean.equals("Y") && author_boolean.equals("Y")) {
      // unknown journal, known author
      runAdminStatement(username, password,
              "call add_paper_with_known_author_and_new_journal('"+title+"', '"+month+"', "+year+", "
                      + "'"+abstr+"', '"+pages+"', "+author_id+", '"+journal_name+"', "
                      + "'"+journal_issue_number+"', "+journal_year+" )");

    } else {
      // unknown journal, unknown author
      runAdminStatement(username, password,
              "call add_paper_with_new_author_and_new_journal('"+fName+"', "
                      + "'"+lName+"', '"+degree+"', '"+institution+"', '"+contact+"', "
                      + "'"+title+"', '"+month+"', "+year+", "
                      + "'"+abstr+"', '"+pages+"', '"+journal_name+"', "
                      + ""+journal_issue_number+", "+journal_year+" )");
    }

  }

  public void adminDeletePaper(String username, String password) {
    System.out.println("\nEnter the paper_id of the paper to delete:");
    String delete_id = sc.next();
    System.out.println("Enter C to confirm, or Z to cancel.");
    String input = sc.next();
    if (input.equals("Z")) {
      System.out.println("\nPaper was not deleted.");
      return;
    } else if (input.equals("C")) {
      runAdminStatement(username, password, "call delete_paper("+delete_id+")");
    } else {
      System.out.println("Invalid input.");
    }
  }

  public void adminAddKeyword(String username, String password) {
    System.out.println("\nEnter the paper id of the paper you would like to add a keyword to:");
    String paper_id = sc.next();
    System.out.println("Enter the keyword to add to this paper:");
    String keyword = sc.next();
    System.out.println("Enter C to confirm, or Z to cancel.");
    String input = sc.next();
    if (input.equals("Z")) {
      System.out.println("Keyword not added.");
      return;
    } else if (input.equals("C")) {
      runAdminStatement(username, password, "call add_keyword("+paper_id+", '"+keyword+"')");
    } else {
      System.out.println("Invalid input.");
    }
  }

  public void adminAddCitation(String username, String password) {
    System.out.println("\nEnter the paper id of the paper you would like to add a citation to:");
    String paper_id = sc.next();
    System.out.println("Enter the paper id of the citation to add:");
    String citation_id = sc.next();
    System.out.println("Enter C to confirm, or Z to cancel.");
    String input = sc.next();
    if (input.equals("Z")) {
      System.out.println("Citation not added.");
      return;
    } else if (input.equals("C")) {
      runAdminStatement(username, password, "call add_citation("+paper_id+", "+citation_id+")");
    } else {
      System.out.println("Invalid input.");
    }
  }

  private void runAdminStatement(String username, String password, String query) {
    try (Connection connection =
                 DriverManager.getConnection(dbURL, username, password);
         Statement statement = connection.createStatement()) {

      // statement.execute() returns boolean
      boolean result = statement.execute(query);
      if (result) {
        // result set was returned

        ResultSet rs = statement.getResultSet();
        ResultSetMetaData rsmd = rs.getMetaData();
        int columnsNumber = rsmd.getColumnCount();

        if (!rs.next()) {
          System.out.println("\n0 rows were returned.\n");
        } else {
          do {
            for (int i = 1; i <= columnsNumber; i++) {
              if (i > 1) System.out.print(",  ");
              String columnValue = rs.getString(i);
              System.out.print(rsmd.getColumnName(i) + ": " + columnValue);
            }
            System.out.println("");
          } while (rs.next());
        }
      } else {
        // update count was returned

        int update = statement.getUpdateCount();
        System.out.println("\nRows updated: "+ update);
      }

    } catch (SQLException e) {
      System.out.println(e.getMessage());
    }
  }

  private void runGuest(String username, String password) {
    // walk guest through steps of using database
    try (Connection connection =
                 DriverManager.getConnection(dbURL, username, password);){

      System.out.println("\nGuest user connected.\n");
      guestOptions();

    } catch (SQLException e) {
      System.out.println(e.getMessage());
    }

  }

  private void guestOptions() {

    while (true) {
      System.out.println("\nEnter Q to enter a query \nor R to request an update, \nor Z to quit.");

      String input = sc.next();

      if (input.equals("Z")) {
        System.out.println("Quit.");
        return;
      } else if (input.equals("Q")) {
        guestQuery();
      } else if (input.equals("R")) {
        guestRequestUpdate();
      } else {
        System.out.println("Invalid input.");
        guestOptions();
      }
    }

  }

  private void guestQuery() {
    System.out.println("\nQuery for a research paper, author, or article?");
    System.out.println("Enter P for paper, Au for author, Art for Article, or Z to go back\n");

    String input = sc.next();
    if (input.equals("Z")) {
      return;
    } else if (input.equals("P")) {
      guestQueryPaper();
    } else if (input.equals("Au")) {
      guestQueryAuthor();
    } else if (input.equals("Art")) {
      guestQueryArticle();
    } else {
      System.out.println("Invalid input.\n");
      guestQuery();
    }
  }

  private void guestRequestUpdate() {
    System.out.println("What type of update? \nEnter D to request a delete,"
            + "\nI to request an insert, \nK to request a keyword addition, "
            + "\nor E to edit an entry. Enter Z to go back.");

    //Scanner sc = new Scanner(System.in);
    String input = sc.next();
    if (input.equals("Z")) {
      return;
    } else if (input.equals("D")) {
      // request a delete
      requestDelete();

    } else if (input.equals("I")) {
      // request an insert
      requestInsert();

    } else if (input.equals("K")) {
      // request a keyword addition
      requestKeyword();
    } else if (input.equals("E")) {
      // request an edit
      requestEdit();

    } else {
      System.out.println("Invalid input.");
      guestRequestUpdate();
    }
  }

  private void requestEdit() {
    System.out.println("\nEnter the paper_id of the paper you would like to edit, or Z to go back.");
    String paper_id = sc.next();
    if (paper_id.equals("Z")) {
      return;
    }
    System.out.println("Describe the changes you would like to make, and then hit enter.");
    String edits = sc.next();
    runSQLUpdate("insert into edit_requests (edit_paper_id, edits) values ("+paper_id+", '"
            +edits+"')");
  }

  private void requestInsert() {
    // add article or paper?
    System.out.println("\nEnter A to request an article addition, P to request a paper addition."
            + "\nEnter Z to go back.");
    String input = sc.next();
    if (input.equals("Z")) {
      return;
    } else if (input.equals("A")) {
      System.out.println("Enter article title.");
      String title = sc.next();
      System.out.println("Enter article author.");
      String author = sc.next();
      System.out.println("Enter article publication.");
      String publication = sc.next();
      System.out.println("Enter date of publication.");
      String date = sc.next();
      runSQLUpdate("insert into article_requests (title, author_name, publication_date, publication_name)"
              + " values ('"+title+"','"+author+"' ,'"+date+"' ,'"+publication+"')");
    } else if (input.equals("P")) {

      System.out.println("Enter paper title.");
      String title = sc.next();
      System.out.println("Enter paper author.");
      String author = sc.next();
      System.out.println("Enter paper journal.");
      String journal = sc.next();
      System.out.println("Enter date of publication.");
      String date = sc.next();
      System.out.println("Enter abstract.");
      String abstr = sc.next();
      System.out.println("Enter journal year.");
      String jr_year = sc.next();
      runSQLUpdate("insert into paper_requests (paper_title, author_name, journal_name, paper_date, paper_abstract,"
              + " journal_year) "
              + "values ('"+title+"','"+author+"' ,'"+journal+"' ,'"+date+"', '"+abstr+"', '"+jr_year+"')");

    } else {
      System.out.println("Invalid input.");
      requestInsert();
    }
  }

  private void requestDelete() {
    //Scanner sc = new Scanner(System.in);
    System.out.println("\nEnter paper id to delete, or Z to go back.");
    String paper_id = sc.next();
    if (paper_id.equals("Z")) {
      return;
    }
    System.out.println("Enter reason why.");
    String reason = sc.next();
    runSQLUpdate("insert into delete_requests (paper_id, reason) values ("+
            paper_id+",'"+reason+"')");
  }

  private void requestKeyword() {
    System.out.println("\nEnter paper id to update, or Z to go back.");
    String paper_id = sc.next();
    if (paper_id.equals("Z")) {
      return;
    }
    System.out.println("Enter keyword to add to the paper.");
    String keyword = sc.next();
    runSQLUpdate("insert into keyword_requests (paper_id, keyword) values ("
            +paper_id+", '"+keyword+"')");
  }

  private void guestQueryPaper() {
    System.out.println("\nTo query by title of paper, enter \"T\"");
    System.out.println("To query by author of paper, enter \"A\"");
    System.out.println("To query by keyword of paper, enter \"K\"");
    System.out.println("To query by journal of paper, enter \"J\"");
    System.out.println("Enter Z to go back.");

    String input = sc.next();
    if (input.equals("Z")) {
      return;
    } else if (input.equals("T")) {

      System.out.println("Enter title:");
      input = sc.next();
      runSQLStatement("call getPaperByTitle('"+input+"')");

    } else if (input.equals("A")) {
      System.out.println("Enter author:");
      input = sc.next();
      runSQLStatement("call getPaperByAuthor('"+input+"')");

    } else if (input.equals("K")) {
      System.out.println("Enter keyword to search by:");
      input = sc.next();
      runSQLStatement("call getPaperByKeyword('"+input+"')");

    }else if (input.equals("J")) {
      System.out.println("Enter journal:");
      input = sc.next();
      runSQLStatement("call getPaperByJournal('"+input+"')");
    } else {
      System.out.println("Invalid input.");
    }

    guestQueryOnPaper();
  }

  private void guestQueryOnPaper() {
    System.out.println("\nEnter a paper id number to perform a query using that paper, \nor"
            + " enter Z to return to previous menu.");
    //Scanner sc = new Scanner(System.in);
    String input = sc.next();

    if (input.equals("Z")) {
      return;
    } else {
      String paper_id = input;

      try {
        int input_number = Integer.parseInt(paper_id);
      } catch (NumberFormatException e) {
        System.out.println("Invalid input.");
        guestQueryOnPaper();
        return;
      }

      System.out.println("\nEnter A to get articled cited by that paper, C to get papers"
              + " that cite that paper, or B to get papers cited by that paper.");
      input = sc.next();

      if (input.equals("A")) {
        runSQLStatement("call getArticleByPaperCitation("+paper_id+")");
      } else if (input.equals("C")) {
        runSQLStatement("call getPapersThatCiteThisOne("+paper_id+")");
      } else if (input.equals("B")) {
        runSQLStatement("call getPapersCitedByThisOne("+paper_id+")");
      } else {
        System.out.println("Invalid input.");
        guestQueryOnPaper();
      }
    }

  }

  private void guestQueryAuthor() {
    System.out.println("\nTo get information about an author, enter their name. "
            + "\nEnter Z to go back.");

    String input = sc.next();

    if (input.equals("Z")) {
      return;
    }

    runSQLStatement("call getAuthorByName('"+input+"')");
  }

  private void guestQueryArticle() {
    System.out.println("\nTo query article by title, enter \"T\"");
    System.out.println("To query article by writer, enter \"W\"");
    System.out.println("To query article by cited paper, enter \"P\"");
    System.out.println("Enter Z to go back.");


    String input = sc.next();
    if (input.equals("Z")) {
      return;
    } else if (input.equals("T")) {
      System.out.println("Enter title:");
      input = sc.next();
      runSQLStatement("call getArticleByTitle('"+input+"')");

    } else if (input.equals("W")) {
      System.out.println("Enter writer's name:");
      input = sc.next();
      runSQLStatement("call getArticleByAuthor('"+input+"')");

    } else if (input.equals("P")) {
      System.out.println("Enter the paper id of the cited paper:");
      input = sc.next();
      runSQLStatement("call getArticleByPaperCitations("+input+")");

    } else {
      System.out.println("Invalid input.");
      guestQueryArticle();
      return;
    }

    guestQuerySpecificArticle();
  }

  private void guestQuerySpecificArticle() {
    System.out.println("\nEnter Z to go back, or enter an article id to get papers cited by that"
            + "article");

    //Scanner sc = new Scanner(System.in);
    String input = sc.next();

    if (input.equals("Z")) {
      return;
    } else {
      runSQLStatement("call getPapersCitedByArticle("+input+")");
    }
  }

  private void runSQLUpdate(String query) {
    try (Connection connection =
                 DriverManager.getConnection(dbURL, "guest", "guest_user");
         Statement statement = connection.createStatement();){

      int result = statement.executeUpdate(query);

      System.out.println("Rows updated: "+result);

    } catch (SQLException e) {
      System.out.println(e.getMessage());
    }
  }

  private void runSQLStatement(String query) {
    try (Connection connection =
                 DriverManager.getConnection(dbURL, "guest", "guest_user");
         Statement statement = connection.createStatement();
         ResultSet rs = statement.executeQuery(query)){

      ResultSetMetaData rsmd = rs.getMetaData();
      int columnsNumber = rsmd.getColumnCount();
      if (!rs.next()) {
        System.out.println("\n0 rows were returned.\n");
      } else {
        do {
          for (int i = 1; i <= columnsNumber; i++) {
            if (i > 1) System.out.print(",  ");
            String columnValue = rs.getString(i);
            System.out.print(rsmd.getColumnName(i) + ": " + columnValue);
          }
          System.out.println("");
        } while (rs.next());
      }


    } catch (SQLException e) {
      System.out.println(e.getMessage());
    }
  }


}
