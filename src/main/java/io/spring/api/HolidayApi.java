package io.spring.api;

import io.spring.application.HolidayQueryService;
import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
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
  public ResponseEntity getNextHoliday() {
    return ResponseEntity.ok(
        new HashMap<String, Object>() {
          {
            put("holiday", holidayQueryService.findNextHoliday());
          }
        });
  }
}
