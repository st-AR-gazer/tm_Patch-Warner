int absoluteStartTime = -1;
auto PreviousCountdownTime;

auto CountdownTime;

int absolute(int value) {
    return value < 0 ? -value : value;
}

void time(float dt) {
    if (10 >= CountdownTime) {
        CountdownTime = 10;
    }
    
    if (CountdownTime == 11000 && absoluteStartTime == -1) {
        absoluteStartTime = Time::get_Now();
    }

    CountdownTime -= int(dt);

    if (CountdownTime <= 0) {
        absoluteStartTime = -1;
    } else {
        int elapsedTime = Time::get_Now() - absoluteStartTime;
        int expectedCountdown = 11000 - elapsedTime;

        if (absolute(CountdownTime - expectedCountdown) > 10) {
            CountdownTime = expectedCountdown;
        }
    }

    PreviousCountdownTime = CountdownTime;
}