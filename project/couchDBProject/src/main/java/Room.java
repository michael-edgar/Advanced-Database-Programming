import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.google.gson.JsonParser;
import com.google.gson.annotations.SerializedName;

public class Room {
    @SerializedName("_id")
    private String id;
    @SerializedName("_rev")
    private String rev;
    private int roomNumber;
    private RoomType roomType;

    public Room(String id, String rev, int roomNumber, RoomType roomType) {
        setId(id);
        setRev(rev);
        setRoomNumber(roomNumber);
        setRoomType(roomType);
    }

    public Room(int roomNumber, RoomType roomType) {
        setRoomNumber(roomNumber);
        setRoomType(roomType);
    }

    @Override
    public String toString() {
        StringBuilder room = new StringBuilder("{");
        if(id != null)
            room.append("\"_id\": \"").append(getId()).append("\", ");
        if(rev != null)
            room.append("\"_rev\": \"").append(getRev()).append("\", ");

        room.append("\"roomNumber\": \"")
                .append(getRoomNumber())
                .append("\", \"roomType\": ")
                .append(getRoomType().name())
                .append("}");
        return room.toString();
    }

    public JsonObject toJson() {
        try {
            JsonParser parser = new JsonParser();
            return  (JsonObject)parser.parse(this.toString());
        }
        catch (JsonParseException err) {
            throw new JsonParseException("Unable to parse room");
        }
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(int roomNumber) {
        this.roomNumber = roomNumber;
    }

    public RoomType getRoomType() {
        return roomType;
    }

    public void setRoomType(RoomType roomType) {
        this.roomType = roomType;
    }

    public String getRev() {
        return rev;
    }

    public void setRev(String rev) {
        this.rev = rev;
    }
}
