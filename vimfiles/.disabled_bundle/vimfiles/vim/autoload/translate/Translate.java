/**
 * Copyright (c) 2008 - 2009 Eric Van Dewoestine
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import java.util.EnumSet;

import com.google.api.translate.Language;

/**
 * Simple program which utilizes google's translation api to translate text from
 * one language to another.
 *
 * @author Eric Van Dewoestine
 */
public class Translate
{
  /**
   * Translate the given text from the source language to the target language.
   *
   * Example, translating from english to german.
   * java -cp google-api-translate-java-0.91.jar:. Translate "Hello World" en de
   *
   * @param args
   */
  public static final void main(String[] args)
    throws Exception
  {
    // print out a list of supported languages to be used by vim command
    // completion.
    if(args.length == 1 && "-c".equals(args[0])){
      // next version should be using enums
      for (Enum lang : EnumSet.allOf(Language.class)){
        System.out.print(lang + " ");
      }
      System.out.println();
      return;
    }

    if(args.length != 3){
      System.err.println("error: invalid arguments");
      System.out.println("Usage:");
      System.out.print("  java -cp google-api-translate-java-0.53.jar:. ");
      System.out.println("Translate \"Hello World\" en de");
      System.exit(1);
    }

    String text = args[0].trim();
    text = text.replaceAll("\n", " && ");

    Language slang = Language.fromString(args[1]);
    Language tlang = Language.fromString(args[2]);
    com.google.api.translate.Translate.setHttpReferrer("none");
    String translation =
      com.google.api.translate.Translate.execute(text, slang, tlang);
    translation = translation.replaceAll(" & & ", "\n");
    System.out.println(translation);

    System.exit(0);
  }
}
