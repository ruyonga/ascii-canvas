defmodule AsciiCanvas.Canvas.DrawImage do
  @moduledoc false
  alias AsciiCanvas.Utils.Helper
  alias AsciiCanvas.Canvas
  import Mogrify

  def draw(image_params) do
    image_name =
      :os.system_time(:millisecond)
      |> Integer.to_string()

    image =
      %Mogrify.Image{path: "#{image_name}.png", ext: "png"}
      |> custom("size", "580x580")
      |> canvas("white")
      |> custom("fill", "black")
      |> Mogrify.Draw.text(10, 50, create_horizontal_boarder(10, "&"))
      |> custom("draw", " translate 50,50 rotate -90 text #{10},#{50} '#{create_vertical_boarder(4, "&")}'")
      |> Mogrify.Draw.text(10, 100, create_horizontal_boarder(10, "&"))
      |> create(path: image_path(image_name))
    print_art(image_params)
    save_image_url("#{image_name}.png")
  end

  defp print_art(image_params) do

    image_params
    |> Enum.each(fn x ->
      x = Helper.atomize_map_keys(x)
      rectangle(x.length, x.width, x.boarder, x.fill) end)
  end


  defp save_image_url(url), do: Canvas.create_image(%{"url" => url})

  defp create_horizontal_boarder(width, c),
       do:
         Enum.into(1..width, [], fn _x -> c end)
         |> List.to_string()

  defp create_vertical_boarder(height, c),
       do:
         Enum.into(1..height, [], fn _x -> c end)
         |> List.to_string()

  defp create_fill(width, fill),
       do:
         Enum.into(1..(width - 2), [], fn _x -> fill end)
         |> List.to_string()

  def rectangle(r, c, out, inside) do
    Enum.each(
      1..r,
      fn x ->
        Enum.each(
          1..c,
          fn i ->
            if(x == 1 || x == r || i == 1 || i == c) do
              draw_character(out)
            else
              draw_character(inside)
            end
          end
        )
        IO.puts("")
      end
    )
  end

  defp draw_character(c), do: IO.write(c)

  defp image_path(name), do: to_string(:code.priv_dir(:ascii_canvas)) <> "/images/#{name}.png"
end
