//
//  MockMenu.swift
//  MensaMenuWidgetExtension
//
//  Created by Nikolai Madlener on 03.12.21.
//  Copyright © 2021 TUM. All rights reserved.
//

import Foundation

class MockMenu {
    static let shared = MockMenu()
    
    func getMockedMenu() -> Menu? {
        let decoder = JSONDecoder()
        let formatter = DateFormatter.yyyyMMdd
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        do {
            let mealPlan: MealPlan = try decoder.decode(MealPlan.self, from: Data(mockMenuJson.utf8))
            return mealPlan.days.first(where: { !$0.dishes.isEmpty })
        } catch {
            print(error)
        }
        return nil
    }
    
    let mockMenuJson = """
    {
        "number": 46,
        "year": 2021,
        "days": [
            {
                "date": "2021-11-15",
                "dishes": [
                    {
                        "name": "Penne Quattro Formaggi",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "1",
                            "2",
                            "Ei",
                            "Gl",
                            "GlW",
                            "Kn",
                            "Mi"
                        ],
                        "dish_type": "Pasta"
                    },
                    {
                        "name": "Pizza mit frischem Broccoli und roter Paprika",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "1",
                            "2",
                            "Gl",
                            "GlG",
                            "GlW",
                            "Mi",
                            "So"
                        ],
                        "dish_type": "Pizza"
                    },
                    {
                        "name": "Schweinerückensteak mit Steinpilzen in Rahm",
                        "prices": {
                            "students": {
                                "base_price": 1.0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 1.0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 1.0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "Gl",
                            "GlW",
                            "Mi",
                            "S"
                        ],
                        "dish_type": "Grill"
                    },
                    {
                        "name": "Orientalische Reispfanne mit Sesam und Gemüse",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.33,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.55,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 0.66,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "Kn",
                            "Se",
                            "So"
                        ],
                        "dish_type": "Wok"
                    },
                    {
                        "name": "Kartoffelgulasch mit Paprika",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.33,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.55,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 0.66,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "Kn"
                        ],
                        "dish_type": "Studitopf"
                    },
                    {
                        "name": "Tagessuppe",
                        "prices": {
                            "students": {
                                "base_price": 1.0,
                                "price_per_unit": 0.33,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 1.0,
                                "price_per_unit": 0.55,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 1.0,
                                "price_per_unit": 0.66,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [],
                        "dish_type": "Studitopf"
                    },
                    {
                        "name": "Balinesisches Kokoshähnchen",
                        "prices": {
                            "students": {
                                "base_price": 1.0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 1.0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 1.0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "Kn"
                        ],
                        "dish_type": "Fleisch"
                    },
                    {
                        "name": "Balinesisches Kokoshähnchen",
                        "prices": {
                            "students": {
                                "base_price": 1.0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 1.0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 1.0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "Kn"
                        ],
                        "dish_type": "Fleisch"
                    },
                    {
                        "name": "Grünkohl-Hanf-Bällchen mit veganem Soja-Joghurt-Dip",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "3",
                            "So"
                        ],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Curcumareis",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Salzkartoffeln",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Nudeln",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "Gl",
                            "GlW"
                        ],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Süßkartoffel Pommes frites",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "Kn"
                        ],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Rosenkohl",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Vanillecreme mit Sauerkirschen",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "Mi"
                        ],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Vanillecreme mit Sauerkirschen",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "Mi"
                        ],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Vanillecreme mit Sauerkirschen",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "Mi"
                        ],
                        "dish_type": "Beilagen"
                    }
                ]
            },
            {
                "date": "2021-11-16",
                "dishes": [
                    {
                        "name": "Pasta mit Ricotta-Paprika-Sauce",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "Gl",
                            "GlW",
                            "Kn",
                            "Mi"
                        ],
                        "dish_type": "Pasta"
                    },
                    {
                        "name": "Pizza Diavolo mit Mozzarella, scharfer Salami und Jalapenos",
                        "prices": {
                            "students": {
                                "base_price": 1.0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 1.0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 1.0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "1",
                            "2",
                            "3",
                            "Gl",
                            "GlG",
                            "GlW",
                            "Mi",
                            "S",
                            "Sf",
                            "So"
                        ],
                        "dish_type": "Pizza"
                    },
                    {
                        "name": "Halloumi mit Salsa (scharf) und Koriander",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "2",
                            "Mi",
                            "So"
                        ],
                        "dish_type": "Grill"
                    },
                    {
                        "name": "Criollo - Reispfanne mit Bohnen und Gemüse",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.33,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.55,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 0.66,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "Kn",
                            "Sl"
                        ],
                        "dish_type": "Studitopf"
                    },
                    {
                        "name": "Tagessuppe",
                        "prices": {
                            "students": {
                                "base_price": 1.0,
                                "price_per_unit": 0.33,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 1.0,
                                "price_per_unit": 0.55,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 1.0,
                                "price_per_unit": 0.66,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [],
                        "dish_type": "Studitopf"
                    },
                    {
                        "name": "Moussaka mit Gemüse und Schafskäse",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "1",
                            "11",
                            "3",
                            "Ei",
                            "Gl",
                            "GlW",
                            "Kn",
                            "Mi",
                            "Sf"
                        ],
                        "dish_type": "Vegetarisch"
                    },
                    {
                        "name": "Schweineschnitzel Wiener Art",
                        "prices": {
                            "students": {
                                "base_price": 1.0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 1.0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 1.0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "Gl",
                            "GlG",
                            "GlW",
                            "Kn",
                            "Mi",
                            "S"
                        ],
                        "dish_type": "Fleisch"
                    },
                    {
                        "name": "Seelachsfilet (MSC) nach Müllerin Art",
                        "prices": {
                            "students": {
                                "base_price": 1.5,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 1.5,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 1.5,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "1",
                            "Fi",
                            "Gl",
                            "GlW",
                            "Mi",
                            "Sf"
                        ],
                        "dish_type": "Fisch"
                    },
                    {
                        "name": "Pommes frites",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Petersilienkartoffeln",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Kaisergemüse",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Paprikagemüse mit Olivenöl",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "Kn"
                        ],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Topfencreme mit Zwetschgenröster",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "Mi"
                        ],
                        "dish_type": "Beilagen"
                    }
                ]
            },
            {
                "date": "2021-11-17",
                "dishes": [
                    {
                        "name": "Pasta mit getrockneten Tomaten, Kapern und Rucola",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.33,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.55,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 0.66,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "2",
                            "3",
                            "Gl",
                            "GlW"
                        ],
                        "dish_type": "Pasta"
                    },
                    {
                        "name": "Pizza Funghi mit Champignons",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "Gl",
                            "GlG",
                            "GlW",
                            "Mi",
                            "So"
                        ],
                        "dish_type": "Pizza"
                    },
                    {
                        "name": "Hähnchenspieß vom Grill mit Paprika und Zwiebel, dazu Barbecuedip",
                        "prices": {
                            "students": {
                                "base_price": 1.0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 1.0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 1.0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "10",
                            "11",
                            "Kn",
                            "Sf",
                            "Sl"
                        ],
                        "dish_type": "Grill"
                    },
                    {
                        "name": "Hackfleischcurry indische Art",
                        "prices": {
                            "students": {
                                "base_price": 1.0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 1.0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 1.0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "R",
                            "Sc",
                            "ScM",
                            "Sf"
                        ],
                        "dish_type": "Wok"
                    },
                    {
                        "name": "Kokos-Pilz-Topf mit Glasnudeln",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.33,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.55,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 0.66,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "2",
                            "Kn",
                            "Sf"
                        ],
                        "dish_type": "Studitopf"
                    },
                    {
                        "name": "Tagessuppe",
                        "prices": {
                            "students": {
                                "base_price": 1.0,
                                "price_per_unit": 0.33,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 1.0,
                                "price_per_unit": 0.55,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 1.0,
                                "price_per_unit": 0.66,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [],
                        "dish_type": "Studitopf"
                    },
                    {
                        "name": "Gefüllte Paprikaschote mit Tomatensauce",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "2",
                            "Gl",
                            "GlD",
                            "GlW",
                            "Kn",
                            "Mi"
                        ],
                        "dish_type": "Vegetarisch"
                    },
                    {
                        "name": "Reiberdatschi mit Apfelmus",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "3",
                            "Ei"
                        ],
                        "dish_type": "Süßspeise"
                    },
                    {
                        "name": "Gebackene Kartoffelspiralen",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "Gl",
                            "GlW",
                            "Kn"
                        ],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Salzkartoffeln",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Täglich frisches Gemüse",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "Sl",
                            "So"
                        ],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Karotte-Kohlrabi-Spargelgemüse",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Grüne Zuckererbsenschoten",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Mandelpudding mit Sojamilch und Himbeeren",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "Sc",
                            "ScM",
                            "So"
                        ],
                        "dish_type": "Beilagen"
                    }
                ]
            },
            {
                "date": "2021-11-18",
                "dishes": [
                    {
                        "name": "Tortelloni all'arrabiata",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.33,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.55,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 0.66,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "Gl",
                            "GlW",
                            "Kn",
                            "So"
                        ],
                        "dish_type": "Pasta"
                    },
                    {
                        "name": "Pizza quattro stagioni",
                        "prices": {
                            "students": {
                                "base_price": 1.0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 1.0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 1.0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "2",
                            "3",
                            "6",
                            "8",
                            "Gl",
                            "GlG",
                            "GlW",
                            "Mi",
                            "S",
                            "So"
                        ],
                        "dish_type": "Pizza"
                    },
                    {
                        "name": "Fränkische Bratwurst",
                        "prices": {
                            "students": {
                                "base_price": 0.5,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0.5,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0.5,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "3",
                            "8",
                            "R",
                            "S"
                        ],
                        "dish_type": "Grill"
                    },
                    {
                        "name": "Braunes Linsencurry mit Frühlingszwiebeln und Koriander",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.33,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.55,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 0.66,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "Sf",
                            "Sl",
                            "So"
                        ],
                        "dish_type": "Studitopf"
                    },
                    {
                        "name": "Tagessuppe",
                        "prices": {
                            "students": {
                                "base_price": 1.0,
                                "price_per_unit": 0.33,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 1.0,
                                "price_per_unit": 0.55,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 1.0,
                                "price_per_unit": 0.66,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [],
                        "dish_type": "Studitopf"
                    },
                    {
                        "name": "Kaspressknödel",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "2",
                            "Ei",
                            "Gl",
                            "GlW",
                            "Kn",
                            "Mi"
                        ],
                        "dish_type": "Vegetarisch"
                    },
                    {
                        "name": "Rinderbraten mit Rotweinsauce",
                        "prices": {
                            "students": {
                                "base_price": 1.0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 1.0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 1.0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "5",
                            "99",
                            "Gl",
                            "GlG",
                            "GlW",
                            "Kn",
                            "Mi",
                            "R",
                            "Sl",
                            "Sw"
                        ],
                        "dish_type": "Fleisch"
                    },
                    {
                        "name": "Frühlingsrolle mit süßsaurer Sauce",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "Gl",
                            "GlW",
                            "Kn",
                            "Sl"
                        ],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Chinanudeln",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "Gl",
                            "GlW",
                            "Kn",
                            "Sf"
                        ],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Salzkartoffeln",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Kartoffelknödel",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "2",
                            "5",
                            "Sw"
                        ],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Frisches Wurzelgemüse",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "Sl"
                        ],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Chinagemüse mit geröstetem Sesam",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "2",
                            "Gl",
                            "GlW",
                            "Se",
                            "So"
                        ],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Pfirsich-Himbeer-Crumble mit Mandeln",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "Gl",
                            "GlW",
                            "Mi",
                            "Sc",
                            "ScM"
                        ],
                        "dish_type": "Beilagen"
                    }
                ]
            },
            {
                "date": "2021-11-19",
                "dishes": [
                    {
                        "name": "Pasta mit Austernpilzen und Babyspinat",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.33,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.55,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 0.66,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "Gl",
                            "GlW",
                            "Kn"
                        ],
                        "dish_type": "Pasta"
                    },
                    {
                        "name": "Pizza quattro formaggi",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "1",
                            "2",
                            "Gl",
                            "GlG",
                            "GlW",
                            "Mi",
                            "So"
                        ],
                        "dish_type": "Pizza"
                    },
                    {
                        "name": "Forelle Müllerin Art mit Mandelbutter",
                        "prices": {
                            "students": {
                                "base_price": 1.5,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 1.5,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 1.5,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "Fi",
                            "Gl",
                            "GlW",
                            "Mi",
                            "Sc",
                            "ScM"
                        ],
                        "dish_type": "Grill"
                    },
                    {
                        "name": "Karibische Reispfanne mit Kokos, Erdnüssen, Ananas und Paprika",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.33,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.55,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 0.66,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "En",
                            "Kn"
                        ],
                        "dish_type": "Wok"
                    },
                    {
                        "name": "Kichererbsencurry mit Gemüse und Chili",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.33,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.55,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 0.66,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "2",
                            "Kn"
                        ],
                        "dish_type": "Studitopf"
                    },
                    {
                        "name": "Tagessuppe",
                        "prices": {
                            "students": {
                                "base_price": 1.0,
                                "price_per_unit": 0.33,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 1.0,
                                "price_per_unit": 0.55,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 1.0,
                                "price_per_unit": 0.66,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [],
                        "dish_type": "Studitopf"
                    },
                    {
                        "name": "Truthahnschnitzel Art Hawaii mit Currysauce",
                        "prices": {
                            "students": {
                                "base_price": 1.0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 1.0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 1.0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "Gl",
                            "GlW",
                            "Kn",
                            "Mi",
                            "Sf"
                        ],
                        "dish_type": "Fleisch"
                    },
                    {
                        "name": "Dinkelpfannkuchen mit Haselnuss-Nougat-Füllung und Vanillesauce",
                        "prices": {
                            "students": {
                                "base_price": 0,
                                "price_per_unit": 0.75,
                                "unit": "100g"
                            },
                            "staff": {
                                "base_price": 0,
                                "price_per_unit": 0.9,
                                "unit": "100g"
                            },
                            "guests": {
                                "base_price": 0,
                                "price_per_unit": 1.05,
                                "unit": "100g"
                            }
                        },
                        "ingredients": [
                            "Ei",
                            "Gl",
                            "GlD",
                            "Mi",
                            "Sc",
                            "ScH",
                            "So"
                        ],
                        "dish_type": "Süßspeise"
                    },
                    {
                        "name": "Süßkartoffel Pommes frites",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "Kn"
                        ],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Petersilienkartoffeln",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Täglich frisches Gemüse",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "Sl",
                            "So"
                        ],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Blumenkohl-Broccoli",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Gelb-rote Karotten",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [],
                        "dish_type": "Beilagen"
                    },
                    {
                        "name": "Quark mit Mango",
                        "prices": {
                            "students": null,
                            "staff": null,
                            "guests": null
                        },
                        "ingredients": [
                            "Mi"
                        ],
                        "dish_type": "Beilagen"
                    }
                ]
            }
        ],
        "version": "2.1"
    }
"""
    
}
