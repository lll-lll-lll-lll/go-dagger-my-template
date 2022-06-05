package godockerdagger

import "testing"

func add(a, b int) int {
	return a + b
}

func TestMain(t *testing.T) {
	a := 1
	b := 2
	if add(a, b) != 3 {
		t.Errorf("add() = %v, want %v", add(1, 2), 3)
	}
}
