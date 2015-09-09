defmodule SFSObject.DataWrapperTest do
  use ExUnit.Case

  defmodule CoderTest do
    use ExUnit.Case
    import SFSObject

    test "null" do
      assert_roundtrip null
    end

    test "bool" do
      assert_roundtrip bool(true)
      assert_roundtrip bool(false)
    end

    test "byte" do
      assert_roundtrip byte(0)
      assert_roundtrip byte(1)
      assert_roundtrip byte(256), byte(0)
    end

    test "sfsobject" do
      assert_roundtrip object(SFSObject.new)

      assert_roundtrip object(SFSObject.new |> put_null("a"))
      assert_roundtrip object(SFSObject.new |> put_null("b"))
      assert_roundtrip object(SFSObject.new
      |> put_bool("truthy", true) |> put_bool("falsey", false))
    end

    test "sfsobject nested" do
      assert_roundtrip data :object, SFSObject.new
      |> put_object("nested", SFSObject.new |> put_null("null"))
    end

    defp assert_roundtrip(value) do
      assert_roundtrip(value, value)
    end

    defp assert_roundtrip(value, expected) do
      encoded = value |> SFSObject.DataWrapper.Encoder.encode
      { actual, rest } = encoded |> to_string |> SFSObject.DataWrapper.Decoder.decode

      assert expected == actual
      assert <<>> == rest
    end

    defp null, do: data(:null, :null)
    defp bool(value), do: data(:bool, value)
    defp byte(value), do: data(:byte, value)
    defp object(value), do: data(:object, value)

    defp data(type, value) do
      SFSObject.DataWrapper.new(type, value)
    end
  end
end
