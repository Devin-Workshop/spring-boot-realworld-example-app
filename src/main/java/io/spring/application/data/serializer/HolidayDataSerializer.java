package io.spring.application.data.serializer;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import io.spring.application.data.HolidayData;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import org.joda.time.format.ISODateTimeFormat;

public class HolidayDataSerializer extends JsonSerializer<HolidayData> {
  @Override
  public void serialize(HolidayData value, JsonGenerator gen, SerializerProvider serializers)
      throws IOException {
    Map<String, Object> holidayMap = new HashMap<>();
    holidayMap.put("name", value.getName());
    holidayMap.put("date", ISODateTimeFormat.dateTime().withZoneUTC().print(value.getDate()));
    holidayMap.put("daysRemaining", value.getDaysRemaining());

    serializers.defaultSerializeValue(holidayMap, gen);
  }
}
