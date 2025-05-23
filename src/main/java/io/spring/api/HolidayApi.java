package io.spring.api;

import io.spring.application.HolidayQueryService;
import java.util.HashMap;
import org.joda.time.DateTime;
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

    if (referenceDate != null) {
      return ResponseEntity.ok(
          new HashMap<String, Object>() {
            {
              put("holiday", holidayQueryService.findNextHoliday(referenceDate));
            }
          });
    } else {
      return ResponseEntity.ok(
          new HashMap<String, Object>() {
            {
              put("holiday", holidayQueryService.findNextHoliday());
            }
          });
    }
  }
}
