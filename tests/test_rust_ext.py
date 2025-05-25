
# Import the Rust extension module built via maturin
import rust_ext


def test_double_positive():
    assert rust_ext.double(3) == 6


def test_double_zero():
    assert rust_ext.double(0) == 0


def test_double_large():
    assert rust_ext.double(10_000) == 20_000
