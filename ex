package jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TransactionCheck {
	private static final String url = "jdbc:mysql://localhost:3306/mydb";
	private static final String user = "root";
	private static final String password = "1234";
	

    public static void main(String[] args) {
        try {
            if (isCurrentActiveTransaction()) {
                System.out.println("There is an active transaction.");
            } else {
                System.out.println("There is no active transaction.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private static boolean isCurrentActiveTransaction() throws SQLException {
        String sql = "SELECT COUNT(1) AS count FROM INFORMATION_SCHEMA.INNODB_TRX WHERE trx_mysql_thread_id = CONNECTION_ID()";

        try (Connection con = DriverManager.getConnection(url, user, password);
             PreparedStatement statement = con.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            if (resultSet.next()) {
                int count = resultSet.getInt("count");
                return count > 0;
            }
        }

        return false;
    }
}
