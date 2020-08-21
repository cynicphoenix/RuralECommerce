import 'package:flutter/material.dart';

const TextInputDecoration = InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                     borderRadius: const BorderRadius.all(
                      const Radius.circular(30.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                     borderRadius: const BorderRadius.all(
                      const Radius.circular(30.0),
                    ),
                  ),
                );