// Assignment
// Accum Meredith
// accum.m

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class Controller {

  private Model model;
  private Readable rd;
  private Appendable ap;

  public Controller(Readable rd, Appendable ap) {
    //model = new Model();
    this.rd = rd;
    this.ap = ap;
  }

  public void login() {

    while (true) {
      Scanner sc = new Scanner(rd);

      System.out.println("Enter username, or enter \"exit\" to quit:");
      String username = sc.nextLine();
      if (username.equals("exit")) {
        System.out.println("Quit program.");
        return;
      }
      System.out.println("Enter password:");
      String password = sc.nextLine();

      String dbURL = "jdbc:mysql://localhost:3306/accumguojohns?useSSL=false";

      if (username.equals("root")) {
        // admin

        model = new Model(true, dbURL, rd);
        model.run(username, password);

      } else if (username.equals("guest")) {
        // guest user

        model = new Model(false, dbURL, rd);
        model.run(username, password);


      }

    }

  }


}
