package io.spring.api;

import io.spring.application.HolidayQueryService;
import io.spring.application.data.HolidayData;
import java.util.HashMap;
import java.util.Map;
import org.joda.time.DateTime;
import org.joda.time.format.ISODateTimeFormat;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(path = "holiday")
public class HolidayApi {
  private HolidayQueryService holidayQueryService;

  @Autowired
  public HolidayApi(HolidayQueryService holidayQueryService) {
    this.holidayQueryService = holidayQueryService;
  }

  @GetMapping
  public ResponseEntity getNextHoliday(
      @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
          DateTime referenceDate) {

    HolidayData holidayData;
    if (referenceDate != null) {
      holidayData = holidayQueryService.findNextHoliday(referenceDate);
    } else {
      holidayData = holidayQueryService.findNextHoliday();
    }

    Map<String, Object> holidayFields = new HashMap<>();
    holidayFields.put("name", holidayData.getName());
    holidayFields.put(
        "date", ISODateTimeFormat.dateTime().withZoneUTC().print(holidayData.getDate()));
    holidayFields.put("daysRemaining", holidayData.getDaysRemaining());

    Map<String, Object> response = new HashMap<>();
    response.put("holiday", holidayFields);

    return ResponseEntity.ok(response);
  }
}
