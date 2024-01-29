auto PreviousTime;
auto CountdownTime;

void time() {
    uint CurrentTime = Time::get_Now();

    if (CountdownTime > 0) {
        CountdownTime -= CurrentTime - PreviousTime;
        if (CountdownTime < 0) CountdownTime = 0;
    }
    PreviousTime = CurrentTime;
}