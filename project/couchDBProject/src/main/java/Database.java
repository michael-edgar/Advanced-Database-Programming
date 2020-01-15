import com.google.gson.JsonObject;
import org.lightcouch.CouchDbClient;
import org.lightcouch.CouchDbProperties;
import org.lightcouch.Response;

import java.util.ArrayList;
import java.util.List;

public class Database {
    private static CouchDbClient dbClient = Database.connectToDB();

    private static CouchDbClient connectToDB() {
        CouchDbProperties dbProperties = new CouchDbProperties()
                .setDbName("hotel")
                .setCreateDbIfNotExist(false)
                .setProtocol("http")
                .setHost("localhost")
                .setPort(5984);

        return new CouchDbClient(dbProperties);
    }

    public static List<Room> getAllRooms() {
        List<JsonObject> dbRooms = dbClient.view("allRooms/getRooms").includeDocs(true).query(JsonObject.class);
        List<Room> rooms = new ArrayList<Room>();
        for (JsonObject dbRoom: dbRooms) {
            String id = dbRoom.get("_id").getAsString();
            String rev = dbRoom.get("_rev").getAsString();
            int roomNumber = dbRoom.get("roomNumber").getAsInt();
            RoomType type = RoomType.valueOf(dbRoom.get("roomType").getAsString()); //.getRoomFromJSON(dbRoom.get("value").getAsJsonObject())
            rooms.add(new Room(id, rev, roomNumber, type));
        }
        return rooms;
    }

    public static List<RoomType> getAllRoomTypes() {
        List<JsonObject> dbRoomTypes = dbClient.view("allRooms/getRoomTypes").query(JsonObject.class);
        List<RoomType> types = new ArrayList<RoomType>();
        for (JsonObject dbRoomType: dbRoomTypes) {
            String typeName = dbRoomType.get("key").getAsString();
            try {
                types.add(RoomType.valueOf(typeName));
            }
            catch (IllegalArgumentException e) {
                throw new IllegalArgumentException("Could not find room type in enum");
            }
        }
        return types;
    }

    public static int getNumberOfRooms() {
        return dbClient.view("allRooms/getRoomCount").key("Room").queryForInt();
    }

    public static int getSingleRoomsView() {
        return dbClient.view("allRooms/howManySingleRooms").key("SINGLE").queryForInt();
    }

    public static void createRoomTypeInDB(RoomType roomType) {
        Response response = dbClient.save(roomType.toJson());
        System.out.println(response);
    }

    public static void createRoomInDB(Room room) {
        Response response = dbClient.save(room.toJson());
    }

    public static void updateRoomInDB(Room room) {
        Response response = dbClient.update(room.toJson());
    }

    public static void deleteRoomInDB(Room room) {
        Response response = dbClient.remove(room.toJson());
    }

    public static void checkAllRoomTypesInDB() {
        List<RoomType> typesInDB = getAllRoomTypes();
        for(RoomType currentType: RoomType.values()) {
            if(!typesInDB.contains(currentType))
                createRoomTypeInDB(currentType);
        }
    }

    public static void main(String[] args) {
        checkAllRoomTypesInDB();
    }
}
