package io.spring.application.data;

import com.fasterxml.jackson.annotation.JsonRootName;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.joda.time.DateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonRootName("holiday")
public class HolidayData {
  private String name;
  private DateTime date;
  private long daysRemaining;
}
