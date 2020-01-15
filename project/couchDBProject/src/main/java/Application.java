import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class Application {
    public static void main(String[] args) {
        final JFrame hotelReservationSystem = new JFrame("Hotel Room System");
        hotelReservationSystem.setSize(750,250);
        hotelReservationSystem.setLayout(new GridLayout());
        hotelReservationSystem.setLocation(500,50);
        hotelReservationSystem.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        JButton createRoom = new JButton("Create Room");
        createRoom.setSize(150, 250);
        createRoom.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                CreateRoom.createRoomFrame();
            }
        });
        hotelReservationSystem.add(createRoom);
        JButton getAllRooms = new JButton("Get All Rooms");
        getAllRooms.setSize(150, 250);
        getAllRooms.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                GetRooms.roomView();
            }
        });
        hotelReservationSystem.add(getAllRooms);
        JButton roomUpdate = new JButton("Update Room");
        roomUpdate.setSize(750, 500);
        roomUpdate.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                UpdateRoom.updateRooms();
            }
        });
        hotelReservationSystem.add(roomUpdate);
        JButton deleteRoom = new JButton("Delete Room");
        deleteRoom.setSize(150, 250);
        deleteRoom.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                DeleteRoom.deleteRoomFrame();
            }
        });
        hotelReservationSystem.add(deleteRoom);
        JButton singleRooms = new JButton("Single Rooms");
        singleRooms.setSize(150, 250);
        singleRooms.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                JOptionPane.showMessageDialog(null, "Number of rooms of type SINGLE: " + Database.getSingleRoomsView());
            }
        });
        hotelReservationSystem.add(singleRooms);
        hotelReservationSystem.setVisible(true);
    }
}
