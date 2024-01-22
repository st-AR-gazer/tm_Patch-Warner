int absoluteStartTime = -1;
auto PreviousCountdownTime;
auto PreviousTime;

auto CountdownTime;

// int absolute(int value) {
//     return value < 0 ? -value : value;
// }

void time() {
    uint CurrentTime = Time::get_Now();

    if (CountdownTime > 0) {
        CountdownTime -= CurrentTime - PreviousTime;
        if (CountdownTime < 0) CountdownTime = 0;
    }
    PreviousTime = CurrentTime;
}